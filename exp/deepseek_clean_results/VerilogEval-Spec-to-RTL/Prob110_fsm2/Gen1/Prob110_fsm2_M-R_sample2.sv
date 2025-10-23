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

    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                       (state == ON)  ? (k ? OFF : ON) :
                       OFF; // Default case (shouldn't occur)

    // State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output depends only on current state (Moore machine)
    assign out = (state == ON);

endmodule