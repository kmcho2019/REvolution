module right_shifter (
    input wire clk,
    input wire d,            // Serial input for shift mode
    input wire mode,         // 0 = shift, 1 = parallel load
    input wire [7:0] pdata,  // Parallel input data
    output reg [7:0] q       // Output register
);

always @(posedge clk) begin
    if (mode) begin
        // Parallel load mode
        q <= pdata;
    end else begin
        // Right shift mode with new bit insertion
        q <= {d, q[7:1]};
    end
end

endmodule