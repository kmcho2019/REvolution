module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Combinational next state logic
assign next_q = areset ? 4'b0 :
                load ? data :
                ena ? {1'b0, q_reg[3:1]} :
                q_reg;

// Sequential state storage
always @(posedge clk or posedge areset) begin
    if (areset)
        q_reg <= 4'b0;
    else
        q_reg <= next_q;
end

assign q = q_reg;

endmodule