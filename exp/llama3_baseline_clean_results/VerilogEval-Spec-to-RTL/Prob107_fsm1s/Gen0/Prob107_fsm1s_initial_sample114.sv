// Define the states as an enumeration
enum logic [0:0] {B, A} state, next_state;

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Sequential logic: state registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic: next state and output logic
always_comb begin
    case (state)
        B: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b1;
        end
        A: begin
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1'b0;
        end
        default: begin
            next_state = B;
            out = 1'b1;
        end
    endcase
end

endmodule