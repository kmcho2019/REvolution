module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Combinational next state logic
assign next_q = (reset) ? 4'b0000 : 
                (slowena) ? ((q_reg == 4'b1001) ? 4'b0000 : q_reg + 1'b1) : 
                q_reg;

// Sequential state storage
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule