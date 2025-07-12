module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == STATE_A) ? (in ? STATE_A : STATE_B)
                                     : (in ? STATE_B : STATE_A);

    // State storage with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;  // Async reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Direct state assignment to output
    assign out = state;

endmodule