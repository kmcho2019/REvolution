module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

always @(*) begin
    // Directly implementing the logic from the Karnaugh map
    // But doing so in a more explicit, step-by-step manner
    if (a) begin
        out = 1'b1; // If 'a' is 1, 'out' is 1 regardless of 'b' and 'c'
    end else if (b && c) begin
        out = 1'b1; // If both 'b' and 'c' are 1, 'out' is 1
    end else if (b && !c) begin
        out = 1'b1; // If 'b' is 1 and 'c' is 0, 'out' is 1
    end else if (!b && c) begin
        out = 1'b1; // If 'b' is 0 and 'c' is 1, 'out' is 1
    end else begin
        out = 1'b0; // If none of the above conditions are met, 'out' is 0
    end
end

endmodule