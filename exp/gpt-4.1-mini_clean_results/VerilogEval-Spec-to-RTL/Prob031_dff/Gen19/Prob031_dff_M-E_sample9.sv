module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Internal register to hold state of DFF
    reg state;

    // Sequential logic: update state on positive edge of clk
    always @(posedge clk) begin
        state <= d;
    end

    // Output driven continuously from internal register
    assign q = state;
endmodule