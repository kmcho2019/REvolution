module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output q
);
    // Instantiate the DFF module directly, passing inputs and connecting output
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule