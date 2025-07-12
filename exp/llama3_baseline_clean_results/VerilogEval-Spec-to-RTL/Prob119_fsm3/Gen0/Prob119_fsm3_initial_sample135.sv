module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        A: if (~in) next_state = A;
           else next_state = B;
        B: if (~in) next_state = C;
           else next_state = B;
        C: if (~in) next_state = A;
           else next_state = D;
        D: if (~in) next_state = C;
           else next_state = B;
        default: next_state = A;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) state <= A;
    else state <= next_state;
end

endmodule