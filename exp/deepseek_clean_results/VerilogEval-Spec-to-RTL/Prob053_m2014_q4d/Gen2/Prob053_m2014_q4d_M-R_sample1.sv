module TopModule (
    input clk,
    input in,
    output out
);

    wire d, q;
    reg q_reg;

    // XOR operation between input and current output
    assign d = in ^ q;

    // Positive edge-triggered behavior using continuous assignment
    assign q = (posedge clk) ? d : q_reg;

    // Store the previous value
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output assignment
    assign out = q;

endmodule