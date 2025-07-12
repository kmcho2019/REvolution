module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] { B, A } state, next_state;

// Output logic
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        B: next_state = (in == 1'b1) ? B : A;
        A: next_state = (in == 1'b1) ? A : B;
        default: next_state = B;
    endcase
end

endmodule