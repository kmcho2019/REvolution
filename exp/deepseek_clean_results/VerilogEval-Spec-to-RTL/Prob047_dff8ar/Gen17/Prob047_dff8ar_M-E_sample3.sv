module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Local parameter for reset value (could be made module parameter)
localparam RESET_VAL = 1'b0;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg q_reg;
        
        always @(posedge clk or posedge areset) begin
            if (areset) begin
                q_reg <= RESET_VAL;
            end
            else begin
                q_reg <= d[i];
            end
        end
        
        assign q[i] = q_reg;
    end
endgenerate

endmodule