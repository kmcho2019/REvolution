module TopModule (
    input  clk,
    input  a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (~prev_a && a) begin
        q <= 0;
    end else if (prev_a && ~a) begin
        q <= 1;
    end else begin
        q <= q; // Hold previous state
    end
end

endmodule