module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Combinational logic for next_state using continuous assignment
assign next_state = (a & b) ? ~state :
                    (~a & b) ? ~state :
                    (a & ~b) ? state :
                    1'b0;

// Sequential state update on positive edge of clk
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

// Initialize state for simulation
initial begin
    state = 1'b0;
end

endmodule