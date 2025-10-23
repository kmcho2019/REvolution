module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// Output logic
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Invalid state, should not happen
    endcase
end

// State logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (!in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B; // Invalid state, reset to B
        endcase
    end
end

endmodule