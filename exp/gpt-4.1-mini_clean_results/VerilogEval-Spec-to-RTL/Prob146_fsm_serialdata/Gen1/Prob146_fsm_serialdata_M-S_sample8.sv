module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'd0;
    localparam RECEIVE = 2'd1;
    localparam STOP    = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;     // count 0..7 bits received
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low, pulse only on valid stop bit
            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    if (in == 1'b0) begin
                        state <= RECEIVE; // start bit detected
                    end
                end

                RECEIVE: begin
                    // Shift left, input bit goes into LSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                    if (bit_count == 3'd7) begin
                        state <= STOP; // after receiving 8 bits
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Wait for stop bit
                        state <= STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule