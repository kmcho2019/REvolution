module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        if (q == 1'b0 && a == 1'b0)
            q <= 1'b1;       // Set q to 1 when currently 0 and a=0
        else if (q == 1'b1 && a == 1'b1)
            q <= 1'b0;       // Reset q to 0 when currently 1 and a=1
        else
            q <= q;          // Hold state otherwise
    end
endmodule