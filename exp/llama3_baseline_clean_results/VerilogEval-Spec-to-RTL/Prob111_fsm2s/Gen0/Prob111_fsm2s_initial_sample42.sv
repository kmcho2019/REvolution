module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

// State update logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: if (j) begin
                state <= ON;
            end else begin
                state <= OFF;
            end
            ON:  if (k) begin
                state <= OFF;
            end else begin
                state <= ON;
            end
        endcase
    end
end

endmodule