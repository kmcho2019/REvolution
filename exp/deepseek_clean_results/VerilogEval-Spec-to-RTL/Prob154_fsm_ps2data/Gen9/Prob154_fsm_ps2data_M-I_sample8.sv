module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot encoded states
    reg [2:0] state;
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes[7:0] <= in;
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule