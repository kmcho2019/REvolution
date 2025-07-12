module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Using an always block to update q on the positive edge of clk
always @(posedge clk) begin
    // Directly update q with the input d
    q <= d;
end

endmodule