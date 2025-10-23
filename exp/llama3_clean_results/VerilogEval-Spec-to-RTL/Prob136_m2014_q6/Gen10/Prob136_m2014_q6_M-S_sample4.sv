module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case (state)
        A: next_state = (w == 0) ? B : A;
        B: next_state = (w == 0) ? C : D;
        C: next_state = (w == 0) ? E : D;
        D: next_state = (w == 0) ? F : A;
        E: next_state = (w == 0) ? E : D;
        F: next_state = (w == 0) ? C : D;
        default: next_state = A;
    endcase
end

// Output z logic
assign z = (state == E) || (state == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule