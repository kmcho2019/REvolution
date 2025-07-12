module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10);
            cnt <= (cnt == 2'b10 || (cnt == 2'b0 && !in[3])) ? 2'b0 : cnt + 1'b1;
        end
    end

endmodule