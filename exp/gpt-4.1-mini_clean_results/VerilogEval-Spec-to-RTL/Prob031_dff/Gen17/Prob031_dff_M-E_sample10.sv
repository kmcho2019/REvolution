module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    reg q_reg;

    // Sequential logic: blocking assignment on posedge clk
    always @(posedge clk) begin
        q_reg = d;
    end

    // Continuous assignment connects internal register to output
    assign q = q_reg;

endmodule