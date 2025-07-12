module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
reg next_state;
reg q_out;

always @(*) begin
    // Next state logic
    if (a & b) begin
        next_state = ~state_reg;
    end else if (~a & ~b) begin
        // Toggle after multiple cycles of a=0, b=0
        next_state = ~state_reg;
    end else begin
        next_state = state_reg;
    end

    // Output logic
    if (a) begin
        q_out = state_reg;
    end else begin
        q_out = state_reg ^ b;
    end
end

always @(posedge clk) begin
    state_reg <= next_state;
end

assign q = q_out;
assign state = state_reg;

endmodule