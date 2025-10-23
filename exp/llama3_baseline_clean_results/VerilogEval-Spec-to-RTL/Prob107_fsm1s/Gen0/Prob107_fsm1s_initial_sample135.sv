module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1;
        end
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        default: begin
            next_state = B;
            out = 1;
        end
    endcase
end

endmodule