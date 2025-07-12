module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Binary encoding for states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;
parameter E = 2'b00; // Reusing state codes for simplicity
parameter F = 2'b01; // Reusing state codes for simplicity

// Internal state signal
reg [1:0] current_state;
reg [1:0] next_state;

// State table implementation using case statement for clarity
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

// State flip-flops with synchronized reset
always @(posedge clk)
begin
    if(reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output z using a combinational logic block
assign z = (current_state == E || current_state == F);

endmodule