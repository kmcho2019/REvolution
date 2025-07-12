module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    if (in == 1'b0) begin  // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 8'b0;  // Clear shift register
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                    
                    if (&shift_reg[6:0]) begin  // When 7 bits received (8th comes now)
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        out_byte <= {shift_reg[6:0], in};  // Capture full byte
                        done <= 1'b1;  // Pulse done
                    end
                    state <= IDLE;  // Return to IDLE regardless
                end
            endcase
        end
    end

endmodule