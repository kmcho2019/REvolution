module TopModule (
    input d,
    input ena,
    output reg q
);

// D latch implementation using always block
always @(ena or d) begin
    if (ena) begin
        q <= d;
    end
    // else q holds its value (implicit in Verilog for latches)
end

endmodule