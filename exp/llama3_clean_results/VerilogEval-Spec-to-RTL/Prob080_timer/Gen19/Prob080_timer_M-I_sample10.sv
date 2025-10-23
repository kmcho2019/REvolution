module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] internal_count;

always @(posedge clk) begin
    if (load) begin
        internal_count <= data;
        tc <= 1'b0; // Reset tc when loading
    end else if (internal_count > 0) begin
        internal_count <= internal_count - 1;
    end
    
    // Directly assign tc based on internal_count
    tc <= (internal_count == 10'd0);
end

endmodule