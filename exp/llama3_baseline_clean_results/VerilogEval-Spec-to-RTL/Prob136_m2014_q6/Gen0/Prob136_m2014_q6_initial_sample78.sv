module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Reset state
initial current_state = A;

// Next state logic
always @(*)
begin
    case(current_state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b1) ? E : D;
        F: next_state = (w == 1'b1) ? C : D;
        default: next_state = A;
    endcase
end

// Output logic
always @(*)
begin
    case(current_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// State update
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule