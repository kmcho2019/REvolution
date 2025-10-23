module TopModule(
    input  clk,
    input  areset,
    input  [7:0] d,
    output [7:0] q
);

    // Create 8 DFFs with active high asynchronous reset
    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all DFFs to 0
            q_reg <= 8'd0;
        end else begin
            // Update DFFs with input data
            q_reg <= d;
        end
    end

    // Assign output to the internal register
    assign q = q_reg;

endmodule