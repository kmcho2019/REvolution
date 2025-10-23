module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 0;
            done <= 0;
        end else begin
            done <= (cnt == 2);
            cnt <= in[3] ? 1 : (cnt == 0 ? 0 : cnt + 1);
        end
    end

endmodule