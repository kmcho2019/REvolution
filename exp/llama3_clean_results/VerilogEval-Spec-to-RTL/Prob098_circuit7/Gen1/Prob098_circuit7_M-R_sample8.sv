module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0; // If a is 1, set q to 0
    end
end

endmodule