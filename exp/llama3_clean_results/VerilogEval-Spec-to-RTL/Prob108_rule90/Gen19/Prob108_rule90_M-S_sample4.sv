module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left = i ? q_reg[i - 1] : 1'b0;
        wire right = i < 511 ? q_reg[i + 1] : 1'b0;
        
        assign next_state[i] = left ^ right;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule