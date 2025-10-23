module TopModule(
    input clk,
    input a,
    output reg q
);

reg flag = 1'b0; // Flag to track if 'a' has ever been 1

always @(posedge clk) begin
    if (!flag && a) // If 'a' is 1 and flag is 0, set flag to 1
        flag <= 1'b1;
    if (flag) // If flag is 1, set q to 0
        q <= 1'b0;
    else // If flag is 0, set q to 1
        q <= 1'b1;
end

endmodule