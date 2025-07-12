module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states with clear names
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;  // Async reset to state B
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
            endcase
        end
    end

    // Direct state assignment to output (most efficient)
    assign out = state;

endmodule