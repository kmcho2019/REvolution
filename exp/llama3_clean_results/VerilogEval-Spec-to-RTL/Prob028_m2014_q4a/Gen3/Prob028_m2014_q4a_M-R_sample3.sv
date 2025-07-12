module TopModule(
    input  d,
    input  ena,
    output reg q
);

initial q = 1'b0; // Initialize q to a known value

always @(posedge ena) begin
    q <= d; // Use non-blocking assignment
end

endmodule