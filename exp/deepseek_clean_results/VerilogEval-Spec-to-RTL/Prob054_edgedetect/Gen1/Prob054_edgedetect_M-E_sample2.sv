module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 2-bit shift registers for each input bit
    reg [1:0] edge_detect [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in current bit value
            edge_detect[i] <= {edge_detect[i][0], in[i]};
            
            // Detect positive edge (01 pattern)
            pedge[i] <= (edge_detect[i] == 2'b01);
        end
    end

endmodule