module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q;
    end else begin
        // No change if a is 0, q will retain its previous value
    end
end

endmodule