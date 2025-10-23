module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Lookup table for next states
reg [3:0] lut [9:0];

initial begin
    // Initialize the lookup table
    lut[1] = 4'd2;
    lut[2] = 4'd3;
    lut[3] = 4'd4;
    lut[4] = 4'd5;
    lut[5] = 4'd6;
    lut[6] = 4'd7;
    lut[7] = 4'd8;
    lut[8] = 4'd9;
    lut[9] = 4'd10;
    lut[10] = 4'd1; // Wrap around to 1 after 10
end

// Sequential update of the counter
always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset to 1
    end else begin
        count <= lut[count];
    end
end

assign q = count;

endmodule