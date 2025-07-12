module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states as enum
enum {B, A} state, next_state;

// Assign output based on current state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Update state on every clock cycle
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset state to B when reset is active-high
        state <= B;
    end else begin
        // Update state based on current state and input
        case (state)
            B: begin
                if (in == 1'b0) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (in == 1'b0) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
        endcase
    end
end

endmodule