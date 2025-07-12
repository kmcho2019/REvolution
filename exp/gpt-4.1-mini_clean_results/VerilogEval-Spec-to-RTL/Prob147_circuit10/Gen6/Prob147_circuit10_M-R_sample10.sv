module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state combinational logic
assign next_state = (a & b) ? ~state :
                    (b)     ? 1'b1   :
                    (a)     ? 1'b0   :
                              state;

// Output combinational logic based on current state and inputs
assign q = (state & a) | (b & ~state);

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule