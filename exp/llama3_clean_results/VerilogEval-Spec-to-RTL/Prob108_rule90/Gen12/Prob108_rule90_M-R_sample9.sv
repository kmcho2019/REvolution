// New module for a single Rule 90 cell
module Rule90Cell(
    input  left,
    input  right,
    output next_state
);
    
    assign next_state = left ^ right;
    
endmodule

// Refactored TopModule
module TopModule (
    input  clk,
    input  load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Generate 512 Rule90Cell instances
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        
        // Simplified boundary conditions
        assign left = (i == 0)? 0 : q_reg[i - 1];
        assign right = (i == 511)? 0 : q_reg[i + 1];
        
        Rule90Cell cell(
            .left(left),
            .right(right),
            .next_state(q_reg[i]) // Directly assign next_state to q_reg for reduced switching activity
        );
    end
endgenerate

// Sequential logic remains the same
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // No change needed here as q_reg is directly updated within the generate loop
    end
end

assign q = q_reg;

endmodule