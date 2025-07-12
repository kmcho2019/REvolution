module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

reg [9:0] lut [0:999]; // Lookup table to store numbers 0 to 999
reg [9:0] index; // Index into the lookup table

// Initialize the lookup table with numbers 0 to 999
initial begin
    for (int i = 0; i <= 999; i++) begin
        lut[i] = i;
    end
end

always @(posedge clk) begin
    if (reset) begin
        index <= 'd0;
    end else if (index == 10'd999) begin
        index <= 'd0;
    end else begin
        index <= index + 1'd1;
    end
end

assign q = lut[index];

endmodule