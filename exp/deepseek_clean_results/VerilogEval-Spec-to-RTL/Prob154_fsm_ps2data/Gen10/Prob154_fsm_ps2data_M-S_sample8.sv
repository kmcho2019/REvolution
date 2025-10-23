module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 0;
            out_bytes <= 24'bx;
        end else begin
            case (state)
                2'b00: begin // IDLE
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        state <= 2'b01;
                        done <= 0;
                    end
                end
                2'b01: begin // BYTE1
                    out_bytes[15:8] <= in;
                    state <= 2'b10;
                end
                2'b10: begin // BYTE2
                    out_bytes[7:0] <= in;
                    done <= 1;
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule