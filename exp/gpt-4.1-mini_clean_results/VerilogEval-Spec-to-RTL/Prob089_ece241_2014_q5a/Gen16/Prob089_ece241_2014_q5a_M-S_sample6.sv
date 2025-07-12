module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // waiting for first '1' bit
    localparam S1 = 1'b1; // inverting subsequent bits

    reg state;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= (state == S0) ? (x ? S1 : S0) : S1;
    end

    // Output logic (Moore): directly from current state and input
    always @(*) begin
        z = (state == S0) ? x : ~x;
    end

endmodule