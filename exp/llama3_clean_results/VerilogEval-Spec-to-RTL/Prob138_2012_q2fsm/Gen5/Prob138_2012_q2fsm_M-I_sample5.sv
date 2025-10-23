module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes using one-hot encoding for potential area reduction
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Internal state signal
reg [5:0] current_state;
reg [5:0] next_state;

// Initialize state to A at reset
initial current_state = A;

// State table using one-hot encoding
always @(*) begin
    casez (current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Default to state A
    endcase
end

// State flip-flops with clock gating for power reduction
always @(posedge clk) begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// FSM output
assign z = (current_state == E || current_state == F);

endmodule