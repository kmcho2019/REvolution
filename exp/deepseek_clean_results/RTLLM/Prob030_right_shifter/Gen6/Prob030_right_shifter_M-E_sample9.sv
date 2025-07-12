module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg [2:0] wr_ptr;  // Write pointer (0-7)
reg [7:0] data [0:7];  // Individual bit storage

integer i;

initial begin
    wr_ptr = 3'd0;
    for (i = 0; i < 8; i = i + 1) begin
        data[i] = 1'b0;
        q[i] = 1'b0;
    end
end

always @(posedge clk) begin
    // Store new bit at current pointer position
    data[wr_ptr] <= d;
    
    // Update write pointer (circular)
    wr_ptr <= (wr_ptr == 3'd7) ? 3'd0 : wr_ptr + 3'd1;
    
    // Generate parallel output
    for (i = 0; i < 8; i = i + 1) begin
        q[i] <= data[(wr_ptr + i + 1) % 8];
    end
end

endmodule