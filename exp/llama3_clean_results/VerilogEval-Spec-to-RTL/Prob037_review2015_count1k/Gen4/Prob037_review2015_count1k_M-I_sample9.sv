module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else if (count == 10'd999) begin
        count <= 10'd0;
    end else begin
        // Explicitly define the increment to potentially help synthesis
        count <= count + 10'd1;
    end
end

// Explicitly assign the output to ensure synthesis treats it as a priority
assign q = count;

endmodule