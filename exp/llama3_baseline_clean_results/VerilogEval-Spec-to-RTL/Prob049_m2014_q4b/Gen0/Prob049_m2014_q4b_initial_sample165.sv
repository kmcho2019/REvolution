module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // asynchronous reset
    end else begin
        q <= d; // store value of d on positive edge of clk
    end
end

endmodule