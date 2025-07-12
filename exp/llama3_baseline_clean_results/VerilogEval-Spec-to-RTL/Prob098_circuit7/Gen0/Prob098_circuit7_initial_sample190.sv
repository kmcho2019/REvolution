module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (!a) begin
        q <= 1; // If a is 0, set q to 1
    end else if (a && !q) begin
        q <= 0; // If a is 1 and q was previously 0, set q to 0
    end else if (a && q) begin
        q <= 0; // If a is 1 and q was previously 1, set q to 0
    end
end

endmodule