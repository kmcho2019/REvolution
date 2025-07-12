module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg state,
    output     q
);

wire next_state;

// Define next state with priority:
// a=1,b=1: toggle state
// a=1,b=0: reset to 0
// a=0,b=1: set to 1
// a=0,b=0: hold current state
assign next_state = (a & b) ? ~state : 
                    (a & ~b) ? 1'b0 :
                    (~a & b) ? 1'b1 :
                    state;

assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule