module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

assign q = q_reg;

// Multiplexer to select between input data and shifted output
wire [3:0] mux_out;
assign mux_out = (load)? data : (ena)? {1'b0, q_reg[3:1]} : q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= mux_out;
    end
end

endmodule