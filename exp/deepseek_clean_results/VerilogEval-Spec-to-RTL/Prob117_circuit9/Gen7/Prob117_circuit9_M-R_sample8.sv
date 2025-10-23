module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state;
wire [2:0] next_state;

// Initialize state
initial state = 3'd4;

// Combinational next state logic
assign next_state = a ? 3'd4 : 
                   (state == 3'd6) ? 3'd0 : 
                   state + 3'd1;

// Sequential state update
always @(posedge clk) begin
    state <= next_state;
end

// Output assignment
assign q = state;

endmodule