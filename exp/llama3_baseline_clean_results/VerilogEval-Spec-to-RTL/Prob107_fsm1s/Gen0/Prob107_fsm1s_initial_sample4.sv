module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {B, A} current_state, next_state;

// Initialize state
initial current_state = B;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
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
        default: next_state = B;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule