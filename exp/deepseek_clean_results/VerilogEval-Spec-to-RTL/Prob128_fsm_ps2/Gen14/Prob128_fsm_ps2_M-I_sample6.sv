module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [2:0] state;  // One-hot: state[0]=waiting, state[1]=byte1, state[2]=byte2
    reg in3_reg;      // Registered version of in[3]

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // Start in waiting state
            done <= 1'b0;
            in3_reg <= 1'b0;
        end else begin
            in3_reg <= in[3];  // Register in[3] to break timing path
            
            // Default assignments
            done <= 1'b0;
            
            case (state)
                3'b001: begin  // Waiting for start of message
                    if (in3_reg) begin
                        state <= 3'b010;  // Move to byte1 state
                    end
                end
                
                3'b010: begin  // Received byte1
                    state <= 3'b100;  // Move to byte2 state
                end
                
                3'b100: begin  // Received byte2
                    state <= 3'b001;  // Return to waiting state
                    done <= 1'b1;    // Assert done after third byte
                end
                
                default: state <= 3'b001;  // Safety net
            endcase
        end
    end

endmodule