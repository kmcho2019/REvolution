module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam START_WAIT = 2'b01;
    localparam RECEIVE    = 2'b10;
    localparam STOP_CHECK = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_idx;  // 4 bits to count up to 8

    // Sequential state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_idx   <= 4'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_idx   <= 4'd0;
                    if (in == 1'b0) // start bit detected
                        state <= START_WAIT;
                end

                START_WAIT: begin
                    // Wait one cycle after start bit detection to sample at bit center
                    state <= RECEIVE;
                    bit_idx <= 4'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in new bit at LSB side, shift left
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_idx <= bit_idx + 1'b1;
                    if (bit_idx == 4'd7)
                        state <= STOP_CHECK;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;  // Valid byte received
                        state <= IDLE;
                    end else begin
                        // Bad stop bit, wait here until stop bit is detected
                        state <= STOP_CHECK;
                    end
                    shift_reg <= 8'd0;
                    bit_idx <= 4'd0;
                    if (in == 1'b1)
                        state <= IDLE;  // Leave wait once valid stop bit seen
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule