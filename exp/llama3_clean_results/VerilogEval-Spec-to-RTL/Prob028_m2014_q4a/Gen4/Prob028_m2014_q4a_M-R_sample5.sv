module TopModule(
    input  d,
    input  ena,
    output reg q
);

initial q = 1'b0; // Initialize q to a known value

always @(d or ena) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment
    end else begin
        q <= q; // Retain the previous value of q
    end
end

endmodule