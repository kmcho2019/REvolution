module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [0:0] { B, A } state, next_state;

// Output based on the state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx;
    endcase
end

// State transitions
always_comb begin
    case (state)
        B: begin
            if (in == 1'b0) next_state = A;
            else next_state = B;
        end
        A: begin
            if (in == 1'b0) next_state = B;
            else next_state = A;
        end
        default: next_state = 1'bx;
    endcase
end

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule