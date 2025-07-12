module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Registers for pipeline stages
reg [7:0] curr_in_reg;
reg [7:0] prev_in_reg;
reg [7:0] pedge_reg;

// Always block to update pipeline registers
always @(posedge clk) begin
    // First stage: Capture current input
    curr_in_reg <= in;
    
    // Second stage: Detect positive edges
    prev_in_reg <= curr_in_reg;
    pedge_reg <= (curr_in_reg & (~prev_in_reg));
end

// Assign the output of the pipeline
assign pedge = pedge_reg;

endmodule