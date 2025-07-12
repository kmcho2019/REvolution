module right_shifter (
    input  wire       clk,
    input  wire       rst_n,  // Active-low synchronous reset
    input  wire       d,
    output reg  [7:0] q
);

wire [7:0] shifted_value;
assign shifted_value = {d, q[7:1]};

always @(posedge clk) begin
    if (!rst_n) begin
        q <= 8'b0;
    end else if (shifted_value != q) begin
        q <= shifted_value;
    end
end

endmodule