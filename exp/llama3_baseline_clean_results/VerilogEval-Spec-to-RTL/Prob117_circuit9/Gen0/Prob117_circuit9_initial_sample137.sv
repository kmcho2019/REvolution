module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (q == 3'bxxx) begin // At the start, q is unknown
        q <= 4; // Initialize q to 4
    end else if (a == 1'b0) begin
        q <= q + 1'b1; // Increment q when a is 0
    end else begin
        q <= q; // Keep q the same when a is 1
    end
end

endmodule