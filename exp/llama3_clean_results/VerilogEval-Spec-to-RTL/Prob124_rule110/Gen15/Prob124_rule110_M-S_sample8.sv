module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

integer i;
genvar j;
generate
    for (j = 0; j < 512; j++) begin
        wire left, center, right;
        
        // Handle boundary conditions
        assign left = (j == 0) ? 1'b0 : current_state[j-1];
        assign center = current_state[j];
        assign right = (j == 511) ? 1'b0 : current_state[j+1];
        
        // Apply simplified Rule 110 logic
        assign next_state[j] = (left ^ center ^ right) | (~left & center & right);
    end
endgenerate

assign q = current_state;

endmodule