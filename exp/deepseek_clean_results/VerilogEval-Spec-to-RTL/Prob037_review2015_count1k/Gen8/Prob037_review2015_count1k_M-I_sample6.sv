module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] binary_count;
reg wrap_around;

// Binary counter with registered comparison
always @(posedge clk) begin
    if (reset) begin
        binary_count <= 10'd0;
        wrap_around <= 1'b0;
    end
    else begin
        wrap_around <= (binary_count == 10'd998);  // Pre-compute wrap one cycle early
        if (wrap_around)
            binary_count <= 10'd0;
        else
            binary_count <= binary_count + 1'b1;
    end
end

// Binary to Gray code conversion (reduces switching power)
assign q = binary_count ^ (binary_count >> 1);

endmodule