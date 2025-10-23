module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] { B, A } state, next_state;

// Initialize the output
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // default value
    endcase
end

// State transition logic
always @(*) begin
    case (state)
        B: begin
            if (~in) next_state = A;
            else next_state = B;
        end
        A: begin
            if (~in) next_state = B;
            else next_state = A;
        end
        default: next_state = B; // default next state
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= B; // Reset to state B when reset is high
    end else begin
        state <= next_state;
    end
end

endmodule