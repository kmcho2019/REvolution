module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter B = 1'b0; // State B
parameter A = 1'b1; // State A

reg current_state;
reg next_state;

always @(*)
begin
    case(current_state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B;
    endcase
end

always @(posedge clk or posedge areset)
begin
    if(areset)
        current_state <= B;
    else
        current_state <= next_state;
end

assign out = (current_state == A) ? 1'b1 : 1'b0;

endmodule