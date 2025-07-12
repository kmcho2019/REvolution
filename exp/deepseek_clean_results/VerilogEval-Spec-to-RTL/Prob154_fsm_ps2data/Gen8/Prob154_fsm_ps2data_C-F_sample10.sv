module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx; // Don't-care during reset
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in; // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    out_bytes[15:8] <= in; // Store second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes[7:0] <= in; // Store third byte
                    done <= 1'b1;         // Assert done
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule