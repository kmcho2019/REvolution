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
            state <= 0;
            done <= 0;
        end else begin
            done <= 0;
            case (state)
                0: if (in[3]) begin  // IDLE
                    out_bytes[23:16] <= in;
                    state <= 1;
                end
                1: begin  // BYTE2
                    out_bytes[15:8] <= in;
                    state <= 2;
                end
                2: begin  // BYTE3
                    out_bytes[7:0] <= in;
                    done <= 1;
                    state <= 0;
                end
            endcase
        end
    end

endmodule