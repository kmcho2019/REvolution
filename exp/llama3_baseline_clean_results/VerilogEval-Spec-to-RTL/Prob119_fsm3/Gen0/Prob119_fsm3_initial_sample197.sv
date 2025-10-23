module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Sequential logic to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next state and output
always_comb begin
    case (current_state)
        A: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            out = 0;
        end
        C: begin
            if (in) begin
                next_state = D;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        D: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
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