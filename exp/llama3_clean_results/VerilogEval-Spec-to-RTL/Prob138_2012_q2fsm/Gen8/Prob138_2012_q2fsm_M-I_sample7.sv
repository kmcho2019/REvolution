module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State width
parameter STATE_WIDTH = 6;

// State codes (one-hot encoding)
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Internal state signal
reg [STATE_WIDTH-1:0] current_state;
reg [STATE_WIDTH-1:0] next_state;

// State table using LUT
always @(current_state, w)
begin
    case (current_state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops with clock gating
reg clk_enable;
always @(posedge clk)
begin
    if (reset)
        current_state <= A;
    else if (clk_enable)
        current_state <= next_state;
end

// Clock gating logic
always @(current_state, w)
begin
    case (current_state)
        A: clk_enable = w;
        B: clk_enable = w;
        C: clk_enable = w;
        D: clk_enable = w;
        E: clk_enable = w;
        F: clk_enable = w;
        default: clk_enable = 0;
    endcase
end

// Output z
assign z = (current_state == E || current_state == F);

endmodule