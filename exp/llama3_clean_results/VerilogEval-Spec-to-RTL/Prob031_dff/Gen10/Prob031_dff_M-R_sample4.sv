module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize the output to prevent x values
initial q = 0;

// Direct assignment is possible but not recommended for sequential logic
// Instead, we'll maintain the always block for clarity and standard practice
always @(posedge clk) begin
    q <= d;
end

endmodule