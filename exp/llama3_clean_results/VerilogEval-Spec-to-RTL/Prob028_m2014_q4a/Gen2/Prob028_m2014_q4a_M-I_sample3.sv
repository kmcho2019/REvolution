module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) 
        q <= d; // Use non-blocking assignment for sequential logic consistency
    else
        q <= q; // Retain previous value, though this line is implicitly handled by the always block's sensitivity
end

endmodule