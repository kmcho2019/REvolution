module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

// Define the states as an enum
enum logic [1:0] {A, B, C, D} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to state A on asynchronous reset
        state <= A;
    end else begin
        // Update the state on the positive edge of the clock
        state <= next_state;
    end
end

// Combinational logic to determine the next state and output
always_comb begin
    case (state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (!in) begin
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