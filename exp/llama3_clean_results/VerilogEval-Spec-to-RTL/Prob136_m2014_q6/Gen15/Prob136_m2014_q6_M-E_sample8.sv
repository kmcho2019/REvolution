module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using one-hot encoding
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// State register
reg [5:0] currentState;

// LUT for next state determination
reg [5:0] nextState;

always @(*) begin
    case ({currentState, w})
        {A, 1'b0}: nextState = B;
        {A, 1'b1}: nextState = A;
        {B, 1'b0}: nextState = C;
        {B, 1'b1}: nextState = D;
        {C, 1'b0}: nextState = E;
        {C, 1'b1}: nextState = D;
        {D, 1'b0}: nextState = F;
        {D, 1'b1}: nextState = A;
        {E, 1'b0}: nextState = E;
        {E, 1'b1}: nextState = D;
        {F, 1'b0}: nextState = C;
        {F, 1'b1}: nextState = D;
        default: nextState = A;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

// Output z logic
assign z = (currentState == E) || (currentState == F);

endmodule