module TopModule(
    input x,
    input y,
    output reg z
);

reg [1:0] state; // 2 states: S0 (00) and S1 (01), S2 (10) for both x and y high

always @(*) begin
    case(state)
        2'b00: // State S0
            if (~x && ~y) begin
                z = 1'b1;
            end else if (x && y) begin
                z = 1'b1;
                state = 2'b10; // Transition to S2
            end else begin
                z = 1'b0;
                state = 2'b01; // Transition to S1
            end
        2'b01: // State S1
            if (~x && y || x && ~y) begin
                z = 1'b0;
            end else if (x && y) begin
                z = 1'b1;
                state = 2'b10; // Transition to S2
            end else begin
                z = 1'b1;
                state = 2'b00; // Transition back to S0
            end
        2'b10: // State S2
            if (x && y) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
                if (~x && ~y) begin
                    state = 2'b00; // Transition back to S0
                end else if (~x && y || x && ~y) begin
                    state = 2'b01; // Transition to S1
                end
            end
    endcase
end

initial begin
    state = 2'b00; // Initialize to state S0
end

endmodule