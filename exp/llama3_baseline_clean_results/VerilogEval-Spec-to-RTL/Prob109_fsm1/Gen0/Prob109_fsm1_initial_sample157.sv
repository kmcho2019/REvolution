module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states as an enum
enum logic [1:0] {B, A} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic and output logic
always_comb begin
    case (state)
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1'b1; // Output based on state B
        end
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b0; // Output based on state A
        end
        default: begin
            next_state = B;
            out = 1'b1; // Default state and output
        end
    endcase
end

endmodule