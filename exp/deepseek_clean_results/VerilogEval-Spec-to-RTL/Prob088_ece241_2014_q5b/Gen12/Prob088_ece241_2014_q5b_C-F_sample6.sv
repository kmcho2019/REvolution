module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding (binary since only 2 states)
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;  // Single bit state (0=A, 1=B)

    // Optimized output logic using XOR
    assign z = state ^ x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            // Simplified next state logic
            state <= (state == STATE_A) ? x : STATE_B;
        end
    end

endmodule