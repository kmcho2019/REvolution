module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding using enum for clarity
    typedef enum logic [0:0] {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state, next_state;

    // Synchronous state and output update
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for state B
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0) begin
                        next_state = A;
                        out <= 1'b0; // output for A
                    end else begin
                        next_state = B;
                        out <= 1'b1; // output for B
                    end
                end
                A: begin
                    if (in == 1'b0) begin
                        next_state = B;
                        out <= 1'b1; // output for B
                    end else begin
                        next_state = A;
                        out <= 1'b0; // output for A
                    end
                end
                default: begin
                    next_state = B;
                    out <= 1'b1;
                end
            endcase
            state <= next_state;
        end
    end

endmodule