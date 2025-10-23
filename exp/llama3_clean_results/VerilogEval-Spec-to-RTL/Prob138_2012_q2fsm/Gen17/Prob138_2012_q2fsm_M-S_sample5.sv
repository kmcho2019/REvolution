module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Maintaining one-hot encoding for its potential benefits
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;
parameter D = 3'b000;
parameter E = 3'b011;
parameter F = 3'b101;

// Internal state signal
reg [2:0] current_state;
reg [2:0] next_state;

// Simplifying the state table logic by explicitly defining next states
always @(*)
begin
    case(current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Reset or undefined state handling
    endcase
end

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output z remains efficiently implemented
assign z = (current_state == E || current_state == F);

endmodule