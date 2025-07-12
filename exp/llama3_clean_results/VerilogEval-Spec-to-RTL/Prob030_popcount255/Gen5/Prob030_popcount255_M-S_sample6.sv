module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Define a lookup table for population counts of 8-bit values
reg [7:0] lut [255:0];

// Initialize the lookup table
initial begin
    for (int i = 0; i < 256; i++) begin
        lut[i] = 8'd0;
        for (int j = 0; j < 8; j++) begin
            if (i & (1 << j)) begin
                lut[i] = lut[i] + 1;
            end
        end
    end
end

// Final population count
reg [7:0] count;

always @(*) begin
    // Initialize count
    count = 8'd0;
    
    // Calculate population count
    for (int i = 0; i < 32; i++) begin
        reg [7:0] segment;
        if (i < 31) begin
            segment = in[(i*8)+:8];
        end else begin
            segment = {1'b0, in[(i*8)+:7]};
        end
        count = count + lut[segment];
    end
end

assign out = count;

endmodule