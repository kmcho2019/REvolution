module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

parameter WIDTH = 4;
reg [WIDTH-1:0] q_reg;
wire [WIDTH-1:0] next_q;

// Combinational next-state logic
assign next_q = shift_ena ? {q_reg[WIDTH-2:0], data} :  // Shift operation
                count_ena ? q_reg - 1'b1 :              // Count operation
                q_reg;                                  // Hold state

// Sequential register update with explicit clock
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule