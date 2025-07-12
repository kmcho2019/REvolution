module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

genvar i;
generate
    for (i = 0; i < 512; i = i + 1) begin : rule90_cells
        // Get left and right neighbors with boundary conditions
        wire left = (i == 0) ? 1'b0 : q[i-1];
        wire right = (i == 511) ? 1'b0 : q[i+1];
        
        // Calculate next state
        assign next_q[i] = left ^ right;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule