module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;
wire [3:0] next_state;

// Next state logic
assign next_state = (reset) ? 4'b0000 :
                   (slowena) ? 
                       (state == 4'b1001) ? 4'b0000 : state + 4'b0001 :
                   state;

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output assignment
assign q = state;

endmodule