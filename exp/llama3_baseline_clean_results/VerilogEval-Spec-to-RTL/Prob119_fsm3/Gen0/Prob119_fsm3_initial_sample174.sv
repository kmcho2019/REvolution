module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as an enumeration
enum logic [1:0] {A, B, C, D} state, next_state;

// Sequential logic to update the state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Asynchronous reset to state A
    end else begin
        state <= next_state; // Update the state on the positive edge of the clock
    end
end

// Combinational logic to determine the next state and the output
always_comb begin
    case (state)
        A: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule