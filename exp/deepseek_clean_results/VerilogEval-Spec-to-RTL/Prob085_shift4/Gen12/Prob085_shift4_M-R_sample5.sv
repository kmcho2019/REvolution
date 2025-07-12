module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = areset ? 4'b0 :
                load ? data :
                ena ? {1'b0, q[3:1]} :
                q;

// State storage (DFFs with async reset)
reg [3:0] q_reg;
always @(posedge clk or posedge areset) begin
    if (areset)
        q_reg <= 4'b0;
    else
        q_reg <= next_q;
end

assign q = q_reg;

endmodule