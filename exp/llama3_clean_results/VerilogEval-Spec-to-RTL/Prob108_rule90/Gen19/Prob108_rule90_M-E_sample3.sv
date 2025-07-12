module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state_reg;

// Pipeline stage to compute next state of each cell
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        assign left = (i == 0) ? 1'b0 : q_reg[i - 1];
        assign center = q_reg[i];
        assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
        
        // Simplified Rule 90 logic using XOR
        assign next_state_reg[i] = left ^ right;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state_reg;
    end
end

assign q = q_reg;

endmodule