module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
always @(*)
begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*)
begin
    case (current_state)
        A: if (!in) next_state = A; else next_state = B;
        B: if (!in) next_state = C; else next_state = B;
        C: if (!in) next_state = A; else next_state = D;
        D: if (!in) next_state = C; else next_state = B;
        default: next_state = A;
    endcase
end

// Sequential logic
always @(posedge clk)
begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule