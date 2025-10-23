module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        assign left = (i == 0)? 1'b0 : q_reg[i - 1];
        assign right = (i == 511)? 1'b0 : q_reg[i + 1];
        
        // Apply Rule 90 logic directly without needing 'center'
        assign q[i] = left ^ right;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q;
    end
end

endmodule