module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment for sequential logic
    end
end

endmodule