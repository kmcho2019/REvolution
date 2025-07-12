module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {A, B} state, next_state;

// Sequential logic for state transitions
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        B: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B;
    endcase

    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule