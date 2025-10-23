module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Minimal next-state logic
    wire next_state = state ^ ~in;

    // State register with async reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output register synchronized with clk and reset, matching state (Moore output)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= B;
        else
            out <= state;
    end

endmodule