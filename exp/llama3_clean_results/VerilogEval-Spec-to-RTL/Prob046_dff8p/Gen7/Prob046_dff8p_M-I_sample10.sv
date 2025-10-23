// Improved DFF module with hardcoded reset value
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        // Hardcoded reset value
        case ({3'b000, d[2:0]})
            3'b000: q_reg <= 1'b0;
            3'b001: q_reg <= 1'b1;
            3'b010: q_reg <= 1'b0;
            3'b011: q_reg <= 1'b1;
            3'b100: q_reg <= 1'b1;
            3'b101: q_reg <= 1'b1;
            3'b110: q_reg <= 1'b0;
            3'b111: q_reg <= 1'b0;
            default: q_reg <= 1'b0;
        endcase
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// Improved TopModule with 8 DFFs
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_dff(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule