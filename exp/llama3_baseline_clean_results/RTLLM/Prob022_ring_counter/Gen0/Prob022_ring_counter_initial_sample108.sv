module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] out_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        out_reg <= 8'b0000_0001; // Initialize to the starting state
    end else begin
        out_reg <= {out_reg[6:0], out_reg[7]}; // Circular shift
    end
end

assign out = out_reg;

endmodule