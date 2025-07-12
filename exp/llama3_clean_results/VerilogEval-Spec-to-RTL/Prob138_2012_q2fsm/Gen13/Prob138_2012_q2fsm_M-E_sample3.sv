module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State codes (one-hot encoding)
parameter A = 6'b000001;
parameter B = 6'b000010;
parameter C = 6'b000100;
parameter D = 6'b001000;
parameter E = 6'b010000;
parameter F = 6'b100000;

// Internal state signal
reg [5:0] current_state;
reg [5:0] next_state;

// ROM to store next states
reg [5:0] rom [6:0];

initial begin
    // Initialize ROM with next states
    rom[A] = (w)? B : A;
    rom[B] = (w)? C : D;
    rom[C] = (w)? E : D;
    rom[D] = (w)? F : A;
    rom[E] = (w)? E : D;
    rom[F] = (w)? C : D;
end

// State flip-flops
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Next state logic using ROM
always @(current_state, w)
begin
    case(current_state)
        A: next_state = (w)? B : A;
        B: next_state = (w)? C : D;
        C: next_state = (w)? E : D;
        D: next_state = (w)? F : A;
        E: next_state = (w)? E : D;
        F: next_state = (w)? C : D;
        default: next_state = A;
    endcase
end

// Output z
assign z = (current_state == E || current_state == F);

endmodule