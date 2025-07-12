module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Simplified FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        done <= 1'b0;  // Default done to 0 (one-cycle pulse)
        
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift right
                    if (shift_reg[0]) begin  // When MSB gets set (received 8 bits)
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    state <= IDLE;  // Return to IDLE regardless
                end
            endcase
        end
    end

endmodule