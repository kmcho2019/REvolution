module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Internal reset (tied low for normal operation)
wire rst_n = 1'b1;

// Explicit flip-flop instantiation using always blocks
reg [7:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= 8'b0;
    end else begin
        data_reg <= d;
    end
end

assign q = data_reg;

endmodule