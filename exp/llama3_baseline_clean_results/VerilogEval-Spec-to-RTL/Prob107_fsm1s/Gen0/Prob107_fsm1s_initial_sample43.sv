module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {B, A} state, next_state;

// State transitions
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (~in) state <= A;
                else state <= B;
            end
            A: begin
                if (~in) state <= B;
                else state <= A;
            end
            default: state <= B;
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule