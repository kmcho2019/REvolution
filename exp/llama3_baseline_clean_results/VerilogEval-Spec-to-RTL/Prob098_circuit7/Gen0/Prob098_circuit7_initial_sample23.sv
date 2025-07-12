module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 0) begin
        q <= 1'b1; // Set q high when a is 0
    end else if (a == 1) begin
        q <= 1'b0; // Set q low when a is 1
    end
end

endmodule