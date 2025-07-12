module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(posedge ena or negedge ena) begin
    if (ena) begin
        q <= d; // Capture d when ena goes high
    end else begin
        // Retain previous value of q when ena is low
        // Implicitly, q will keep its value as non-blocking assignment is used
    end
end

endmodule