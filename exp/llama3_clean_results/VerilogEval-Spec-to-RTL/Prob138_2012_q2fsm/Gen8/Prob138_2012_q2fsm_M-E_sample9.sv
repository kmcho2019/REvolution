module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes (one-hot encoding)
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Internal state signals
reg [5:0] current_state;
reg [5:0] next_state;
reg [5:0] next_next_state;

// State table (multiplexer-based)
always @(*)
begin
    case(current_state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A;
    endcase
end

// Pipeline stage 1
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Pipeline stage 2
always @(posedge clk)
begin
    if(reset)
        next_next_state <= A;
    else
        next_next_state <= next_state;
end

// FSM output
assign z = (next_next_state == E) || (next_next_state == F);

endmodule