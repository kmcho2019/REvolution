module TopModule(
    input         clk,
    input  [7:0]  d,
    output logic [7:0]  q // Declare 'q' as a logic type
);

// Implement each D flip-flop individually using always_ff
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always_ff @(posedge clk) begin
            q[i] <= d[i]; // Each bit of q is assigned the corresponding bit of d
        end
    end
endgenerate

endmodule