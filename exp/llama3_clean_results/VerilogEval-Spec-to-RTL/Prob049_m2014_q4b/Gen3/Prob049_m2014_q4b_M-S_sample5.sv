module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if(ar) begin
        q <= 0;
    end else if(clk) begin
        // The above condition will not work because we are checking for posedge clk in the sensitivity list,
        // so the else if condition is not necessary.
        q <= d;
    end
end

endmodule