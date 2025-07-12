module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                                      (k ? OFF : ON);

    // State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    assign out = state;

endmodule