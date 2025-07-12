module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [2:0] state;  // One-hot encoding: [0]=IDLE, [1]=BYTE1, [2]=BYTE2
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // IDLE state
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            case (1'b1)  // Synthesis-friendly one-hot case
                state[0]: begin // IDLE state
                    if (in[3]) begin
                        byte1 <= in;
                        state <= 3'b010;  // Move to BYTE1 state
                    end
                end
                
                state[1]: begin // BYTE1 state
                    byte2 <= in;
                    state <= 3'b100;  // Move to BYTE2 state
                end
                
                state[2]: begin // BYTE2 state
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= 3'b001;  // Return to IDLE
                end
            endcase
        end
    end

endmodule