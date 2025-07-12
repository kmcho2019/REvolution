module TopModule(
    input  d,
    input  ena,
    output reg q
);

reg q_bar; // Complement of q

// Implementing the D latch using nand gates
always @(d or ena) begin
    q_bar <= ~(ena & d) & ~(q & ena);
    q <= ~q_bar;
end

endmodule