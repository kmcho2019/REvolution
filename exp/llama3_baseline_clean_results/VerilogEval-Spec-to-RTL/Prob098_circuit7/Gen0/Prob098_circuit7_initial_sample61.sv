module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 0 && q == 0) begin
        // If q is already 1, this condition won't be true, 
        // and if a is 1, this condition also won't be true.
        q <= 1;
    end else if (a == 1) begin
        // When a becomes 1, set q to 0.
        q <= 0;
    end
end

endmodule