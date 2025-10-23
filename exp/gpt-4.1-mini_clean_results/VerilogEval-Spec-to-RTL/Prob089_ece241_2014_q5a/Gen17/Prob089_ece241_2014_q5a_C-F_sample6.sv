module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    localparam S0 = 1'b0; // waiting for first '1' (carry not started)
    localparam S1 = 1'b1; // carry started, invert bits

    reg state;
    reg x_reg;

    // Input sampling register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with asynchronous reset and simple transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= (state == S0 && x_reg) ? S1 : state;
    end

    // Moore output: pass input bit if in S0, invert input bit if in S1
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule