module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg [7:0] prev_d;

always @(posedge clk) begin
    prev_d <= d;
end

always @(negedge clk) begin
    if(reset) begin
        q_reg <= 8'h34; // Directly using hexadecimal for clarity and efficiency
    end else if (d !== prev_d) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule