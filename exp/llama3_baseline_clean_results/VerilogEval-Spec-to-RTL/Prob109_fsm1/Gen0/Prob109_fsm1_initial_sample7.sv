module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// Asynchronous reset
always @(areset or state) begin
    if (areset) begin
        state = B;
    end
end

// State transition and output logic
always_comb begin
    case (state)
        B: begin
            if (~in) next_state = A;
            else next_state = B;
            out = 1'b1;
        end
        A: begin
            if (~in) next_state = B;
            else next_state = A;
            out = 1'b0;
        end
    endcase
end

// Synchronous state update
always_ff @(posedge clk) begin
    if (~areset) state <= next_state;
end

endmodule