// Refactored code using a for-loop to instantiate 8 DFF modules
module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

// DFF module remains the same as in the original code
module DFF(
    input clk,
    input d,
    output logic q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// Use a for-loop to instantiate 8 DFF modules
generate
    for(genvar i = 0; i < 8; i++) begin
        DFF dff(.clk(clk), .d(d[i]), .q(q[i]));
    end
endgenerate

endmodule

// Alternative refactored code eliminating the separate DFF module
module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule