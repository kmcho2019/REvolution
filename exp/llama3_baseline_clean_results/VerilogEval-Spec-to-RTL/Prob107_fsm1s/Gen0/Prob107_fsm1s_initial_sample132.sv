module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [0:0] { B, A } state, next_state;

// Next state logic
always @(*) begin
    case(state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B; // Default state
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0; // Default output
    endcase
end

endmodule