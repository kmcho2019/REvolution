module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding
    reg state;
    wire next_state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Combinational next state logic
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                       (state == ON)  ? (k ? OFF : ON) :
                       OFF; // Default case (should never occur)

    // Sequential state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule