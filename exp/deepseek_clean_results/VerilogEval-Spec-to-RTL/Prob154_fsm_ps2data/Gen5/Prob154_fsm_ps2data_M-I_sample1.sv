module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam BYTE3 = 4'b1000;
    
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (1'b1) // synthesis parallel_case
                state[0]: begin // IDLE
                    if (in[3]) begin
                        out_bytes <= {in, 16'b0}; // Shift first byte in
                        state <= BYTE1;
                    end
                end
                
                state[1]: begin // BYTE1
                    out_bytes <= {out_bytes[23:16], in, 8'b0}; // Shift second byte in
                    state <= BYTE2;
                end
                
                state[2]: begin // BYTE2
                    out_bytes <= {out_bytes[23:8], in}; // Shift third byte in
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule