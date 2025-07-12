module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Define the reset value
wire [7:0] reset_value = 8'h34;

// Always block to handle reset and clock edge
always @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_value;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule