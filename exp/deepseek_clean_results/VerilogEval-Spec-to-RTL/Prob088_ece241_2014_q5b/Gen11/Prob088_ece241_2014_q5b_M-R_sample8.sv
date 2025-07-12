module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Named one-hot state encoding
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;  // Single bit state (0=A, 1=B)

    // Output logic - Mealy type (depends on state and input)
    assign z = (state == STATE_A) ? x : ~x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            // Next state logic
            state <= (state == STATE_A) ? (x ? STATE_B : STATE_A) : STATE_B;
        end
    end

endmodule