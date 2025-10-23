module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// State table
always @(*) begin
    case (current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase

    // Reset condition
    if (reset) next_state = A;
end

// State flip-flops
always @(posedge clk) begin
    current_state <= next_state;
end

// Output 'z' description
assign z = (current_state == E || current_state == F);

endmodule