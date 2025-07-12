module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {A, B} state, next_state;

// Asynchronous reset
always @(areset or state) begin
    if (areset) begin
        state = B;
    end else begin
        case(state)
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
    end
end

// Synchronous state update
always @(posedge clk) begin
    state <= next_state;
end

// Output logic based on the state
always @(state) begin
    case(state)
        B: out <= 1'b1;
        A: out <= 1'b0;
        default: out <= 1'b0;
    endcase
end

endmodule