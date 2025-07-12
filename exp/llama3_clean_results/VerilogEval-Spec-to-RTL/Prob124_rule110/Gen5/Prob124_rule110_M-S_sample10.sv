module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic to calculate next_state
wire [511:0] next_state;
genvar i;
generate
    for (i = 0; i < 512; i++) begin: next_state_logic
        wire left, center, right;
        assign left = (i == 0) ? 0 : q_reg[i - 1];
        assign center = q_reg[i];
        assign right = (i == 511) ? 0 : q_reg[i + 1];
        
        // Simplified expression for next_state based on Rule 110
        assign next_state[i] = ~(left & center & right) | (~left & center) | (~right & center) | (left & ~center & right);
    end
endgenerate

// Sequential logic to update q_reg
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule