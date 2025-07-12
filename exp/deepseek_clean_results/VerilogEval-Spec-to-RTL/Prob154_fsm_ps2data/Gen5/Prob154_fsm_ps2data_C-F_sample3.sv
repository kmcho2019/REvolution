module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    reg [2:0] state; // IDLE, BYTE1, BYTE2, BYTE3 (one-hot)
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001; // IDLE state
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default assignment
            
            case (1'b1) // Synthesis-friendly case statement
                state[0]: begin // IDLE
                    if (in[3]) begin
                        out_bytes <= {in, 16'b0}; // Store first byte
                        state <= 3'b010; // Move to BYTE1
                    end
                end
                
                state[1]: begin // BYTE1
                    out_bytes <= {out_bytes[23:16], in, 8'b0}; // Shift in second byte
                    state <= 3'b100; // Move to BYTE2
                end
                
                state[2]: begin // BYTE2
                    out_bytes <= {out_bytes[23:8], in}; // Shift in third byte
                    done <= 1'b1;
                    state <= 3'b001; // Return to IDLE
                end
                
                default: state <= 3'b001; // Handle unexpected states
            endcase
        end
    end

endmodule