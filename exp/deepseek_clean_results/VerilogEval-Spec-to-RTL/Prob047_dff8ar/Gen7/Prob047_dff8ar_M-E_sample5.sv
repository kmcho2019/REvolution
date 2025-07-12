module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VALUE = 8'b0;  // Centralized reset value definition

reg [7:0] q_reg;

// Generate block creates all 8 flip-flops in a loop
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge clk or posedge areset) begin
            if (areset) begin
                q_reg[i] <= RESET_VALUE[i];
            end
            else begin
                q_reg[i] <= d[i];
            end
        end
    end
endgenerate

assign q = q_reg;

endmodule