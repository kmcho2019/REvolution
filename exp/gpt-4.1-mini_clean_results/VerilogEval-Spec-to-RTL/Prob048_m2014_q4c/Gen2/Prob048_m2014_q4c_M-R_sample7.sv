module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);
    wire d_mux;

    // Combinational mux: if reset is high, output 0; else, output d
    assign d_mux = r ? 1'b0 : d;

    // Register stage: on posedge clk, capture mux output
    always @(posedge clk) begin
        q <= d_mux;
    end
endmodule