module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] state;
reg [1:0] next_state;

// Output z is a function of current state and input x
assign z = (state[1] || (state[0] && x));

// Next state logic
always @(*) begin
    case(state)
        2'b01: next_state = (x) ? 2'b10 : 2'b01;
        2'b10: next_state = 2'b10;
        default: next_state = 2'b01; // default state is A
    endcase
end

// State update on positive edge of clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // asynchronous reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule