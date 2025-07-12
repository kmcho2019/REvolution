module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (2-bit binary)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg stop_error;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (stop_error) begin
                    if (in == 1'b1)
                        next_state = IDLE; // stop bit found after error
                    else
                        next_state = STOP; // keep waiting
                end else begin
                    // stop bit was correct; after done pulse, go to IDLE
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done <= 1'b0;
            stop_error <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                    stop_error <= 1'b0;
                end
                RECEIVE: begin
                    // Shift right, new bit in MSB for LSB-first serial data
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    bit_count <= 3'd0;
                    if (!stop_error) begin
                        if (in == 1'b1) begin
                            done <= 1'b1; // pulse done on correct stop bit
                            stop_error <= 1'b0;
                        end else begin
                            stop_error <= 1'b1; // error detected, wait for stop bit
                        end
                    end else begin
                        // Waiting for stop bit to arrive, do nothing else
                        // done remains 0
                    end
                end
            endcase
        end
    end

endmodule