module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Enum for states
enum logic [0:0] {B, A} state, next_state;

// State Register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next State Logic
always_comb begin
    case (state)
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
    endcase
end

// Output Logic
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

endmodule