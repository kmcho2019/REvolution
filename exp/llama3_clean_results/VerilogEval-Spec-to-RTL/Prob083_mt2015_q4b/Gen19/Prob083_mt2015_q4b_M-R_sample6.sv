module TopModule(
    input x,
    input y,
    output reg z
);
    // Implement the logic using an always block for combinational logic
    always @(*) begin
        z = !(x ^ y); // The logic expression remains the same
    end
endmodule