module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary encoded states and counter
    reg [1:0] state;
    reg [1:0] byte_cnt;
    localparam IDLE  = 2'b00;
    localparam COLLECT = 2'b01;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_cnt <= 2'b00;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        byte_cnt <= 2'b01;
                        state <= COLLECT;
                    end
                end
                
                COLLECT: begin
                    case (byte_cnt)
                        2'b01: begin
                            out_bytes[15:8] <= in;
                            byte_cnt <= 2'b10;
                        end
                        2'b10: begin
                            out_bytes[7:0] <= in;
                            done <= 1'b1;
                            state <= IDLE;
                        end
                        default: state <= IDLE;
                    endcase
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule