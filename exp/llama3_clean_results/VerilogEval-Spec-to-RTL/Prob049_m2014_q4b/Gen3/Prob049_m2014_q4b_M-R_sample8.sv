module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        // Asynchronous reset condition
        q <= 1'b0;
    end else if (posedge clk) begin
        // Clock edge condition without reset
        q <= d;
    end
end

endmodule