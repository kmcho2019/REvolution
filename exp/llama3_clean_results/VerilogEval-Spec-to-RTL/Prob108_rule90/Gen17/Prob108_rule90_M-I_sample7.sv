module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic to calculate the next state of each cell
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        // Simplified boundary conditions
        assign left = (i == 0)? 1'b0 : q_reg[i - 1];
        assign center = q_reg[i];
        assign right = (i == 511)? 1'b0 : q_reg[i + 1];
        
        // Simplified application of Rule 90 using XOR
        assign next_state[i] = left ^ center ^ right;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule