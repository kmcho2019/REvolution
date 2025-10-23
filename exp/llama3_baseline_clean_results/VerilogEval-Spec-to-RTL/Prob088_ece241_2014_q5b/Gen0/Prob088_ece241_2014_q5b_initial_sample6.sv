module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state_A;
reg state_B;

// Combinational logic for next state
always @(*) begin
    if (areset) begin
        state_A = 1'b1;
        state_B = 1'b0;
    end else if (state_A && x) begin
        state_A = 1'b0;
        state_B = 1'b1;
    end else if (state_B) begin
        state_A = 1'b0;
        state_B = 1'b1;
    end else begin
        state_A = 1'b1;
        state_B = 1'b0;
    end
end

// Combinational logic for output z
always @(*) begin
    if (state_A) begin
        z = x;
    end else begin
        z = ~x; // In state B, z is the opposite of x
    end
end

// Sequential logic to update states on the positive edge of the clock
always @(posedge clk) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        if (state_A && x) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else if (state_B) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
    end
end

endmodule