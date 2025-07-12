module TopModule(
    input x,
    input y,
    output reg z
);
    // Using a MUX-like structure to implement the logic
    always @(*)
    begin
        // Select between y and ~y based on x
        // But to match the truth table, we need to adjust this logic
        // z should be high when x and y match (both high or both low)
        z = (x == y) ? 1'b1 : 1'b0;
    end
endmodule