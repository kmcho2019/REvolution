module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 0; // Asynchronous reset
    end else if (clk) begin
        // Since we're already at the posedge of clk due to the sensitivity list,
        // this condition is implicitly true when ar is not high.
        q <= d; // Clock edge condition
    end
end

endmodule