module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Individual flip-flop implementation
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg q_reg;
        
        // Determine reset value for each bit (0x34 = 8'b00110100)
        wire reset_val = (i == 5 || i == 4 || i == 2) ? 1'b1 : 1'b0;
        
        always @(negedge clk) begin
            if (reset) begin
                q_reg <= reset_val;
            end else begin
                q_reg <= d[i];
            end
        end
        
        assign q[i] = q_reg;
    end
endgenerate

endmodule