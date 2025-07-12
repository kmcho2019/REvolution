module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state;

// Combinational next-state logic
wire [2:0] next_state = a ? 3'd4 : 
                       (state == 3'd6) ? 3'd0 : 
                       state + 1;

// Sequential state update
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule