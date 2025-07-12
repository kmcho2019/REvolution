module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B, next_state_A, next_state_B;

// Next state logic
always @(*) begin
    next_state_A = 1'b0;
    next_state_B = 1'b0;
    if (state_A) begin
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
    end else begin // state_B
        next_state_A = 1'b0;
        next_state_B = 1'b1;
    end
end

// Output logic (Mealy)
assign z = (state_A && x) || (state_B && ~x);

// State register with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule