module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
enum logic [0:0] {B, A} current_state, next_state;

// Output logic based on the current state
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0; // This is just a default value and should never be reached
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
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
        default: next_state = B; // This is just a default value and should never be reached
    endcase
end

endmodule