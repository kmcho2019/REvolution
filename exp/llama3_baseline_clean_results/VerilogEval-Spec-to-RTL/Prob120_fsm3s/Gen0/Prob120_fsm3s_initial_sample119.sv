module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Combinational logic to determine next state and output
always_comb begin
    case (current_state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
            out = 0;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 0;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
            out = 0;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 1;
        end
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule