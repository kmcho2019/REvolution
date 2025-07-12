module TopModule(
    input clk,
    input d,
    output reg q
);

always @(clk or d) begin
    if (clk) begin
        q = d;
    end else begin
        // Maintaining the current state when clk is low
        // This is implicitly handled by the reg type and always block sensitivity
    end
end

endmodule