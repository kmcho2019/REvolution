module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 1'b0, B = 1'b1;

reg [0:0] current_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= B; // Reset state is B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        B: if (!in) next_state = A; else next_state = B;
        A: if (!in) next_state = B; else next_state = A;
        default: next_state = B; // Default state
    endcase
end

// Output logic
assign out = (current_state == B) ? 1'b1 : 1'b0;

endmodule