module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin
                    if (in[3] == 1) begin
                        byte1 <= in;
                        state <= 1;
                    end
                end
                1: begin
                    byte2 <= in;
                    state <= 2;
                end
                2: begin
                    byte3 <= in;
                    state <= 3;
                end
                3: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1;
                    state <= 0;
                end
            endcase
        end
    end

endmodule