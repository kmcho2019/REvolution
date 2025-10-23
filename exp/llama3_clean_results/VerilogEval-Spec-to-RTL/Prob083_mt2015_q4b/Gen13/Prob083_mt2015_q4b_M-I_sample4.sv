module TopModule(
    input x,
    input y,
    output z
);

// Alternative implementation using an always block for combinational logic
always @(*) begin
    z = ~(x ^ y);
end

endmodule