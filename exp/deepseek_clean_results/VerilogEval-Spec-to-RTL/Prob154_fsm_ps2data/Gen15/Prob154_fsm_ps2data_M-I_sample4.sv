module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        out_bytes[23:16] <= in; // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    out_bytes[15:8] <= in;      // Store second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes[7:0] <= in;       // Store third byte
                    done <= 1'b1;              // Assert done
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule