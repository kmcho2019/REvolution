module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg state; // 0: IDLE, 1: COLLECT
    reg [1:0] byte_cnt;
    reg [23:0] msg_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
            byte_cnt <= 2'b0;
            msg_buffer <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default assignment
            
            case (state)
                1'b0: begin // IDLE
                    if (in[3]) begin
                        msg_buffer[23:16] <= in;
                        byte_cnt <= 2'b01;
                        state <= 1'b1;
                    end
                end
                
                1'b1: begin // COLLECT
                    case (byte_cnt)
                        2'b01: begin
                            msg_buffer[15:8] <= in;
                            byte_cnt <= 2'b10;
                        end
                        2'b10: begin
                            msg_buffer[7:0] <= in;
                            out_bytes <= msg_buffer[23:16] << 16 | msg_buffer[15:8] << 8 | in;
                            done <= 1'b1;
                            state <= 1'b0;
                            byte_cnt <= 2'b00;
                        end
                    endcase
                end
            endcase
        end
    end

endmodule