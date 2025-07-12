module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B;
    endcase
end

// Output logic
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule