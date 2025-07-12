module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes (one-hot encoding)
localparam A = 6'b000001;
localparam B = 6'b000010;
localparam C = 6'b000100;
localparam D = 6'b001000;
localparam E = 6'b010000;
localparam F = 6'b100000;

// Internal state signal
reg [5:0] current_state;
reg [5:0] next_state;

// State table
always @*
begin
    case(current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Clock gating
reg clock_enable;
always @*
begin
    clock_enable = (current_state != next_state);
end

// Low-power flip-flop design
reg [5:0] flip_flop_output;
always @(posedge clk)
begin
    if(clock_enable)
        flip_flop_output <= next_state;
end

// FSM output
assign z = (current_state == E) || (current_state == F);

endmodule