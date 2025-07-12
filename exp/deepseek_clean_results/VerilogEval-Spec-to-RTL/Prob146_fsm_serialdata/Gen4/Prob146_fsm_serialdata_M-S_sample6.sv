module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    parameter IDLE = 0, RECEIVE = 1, STOP = 2;
    reg [1:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default done to 0 (one-cycle pulse)
            
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in}; // Left shift (LSB first)
                    if (&shift_reg[6:0]) begin // After 7 shifts, next is 8th bit
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in) begin // Valid stop bit
                        out_byte <= {shift_reg[6:0], in}; // Capture all 8 bits
                        done <= 1'b1;
                    end
                    state <= IDLE; // Return to IDLE regardless of stop bit
                end
            endcase
        end
    end

endmodule