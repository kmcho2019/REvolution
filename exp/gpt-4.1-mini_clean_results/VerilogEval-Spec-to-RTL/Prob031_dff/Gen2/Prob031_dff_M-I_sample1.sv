module TopModule (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (q != d)
            q <= d;
    end
endmodule