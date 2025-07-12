module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            q[i] <= d[i];
        end
    end
endgenerate

// Initialize all flip-flops to 0 at time 0
initial begin
    q = 8'b0;
end

endmodule