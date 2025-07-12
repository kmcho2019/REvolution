module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Combine outputs using XOR
    assign q = q_pos ^ q_neg ^ d;

endmodule