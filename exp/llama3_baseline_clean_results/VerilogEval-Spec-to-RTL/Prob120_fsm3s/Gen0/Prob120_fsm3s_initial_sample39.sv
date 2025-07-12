module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Output logic
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

// State update logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule