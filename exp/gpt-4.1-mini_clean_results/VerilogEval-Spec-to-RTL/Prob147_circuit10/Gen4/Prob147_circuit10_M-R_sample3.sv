module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Combinational logic for next state
wire next_state;

assign next_state = (b & ~a) ? 1'b1 :
                    (b & a)  ? ~state :
                               state;

// Output logic
assign q = state & ~(a & b);

// Sequential state update
always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule