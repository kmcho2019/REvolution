module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state_reg;
wire [2:0] next_state;

// Combinational next state logic
assign next_state = a ? 3'd4 : 
                   (state_reg == 3'd6) ? 3'd0 : 
                   state_reg + 3'd1;

// Sequential state register
always @(posedge clk) begin
    state_reg <= next_state;
end

// Output assignment
assign q = state_reg;

endmodule