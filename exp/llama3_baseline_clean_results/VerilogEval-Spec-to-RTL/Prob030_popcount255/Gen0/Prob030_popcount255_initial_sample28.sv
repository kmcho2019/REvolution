module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Initialize count to 0
always @(*) begin
    count = 8'd0;
    
    // Count '1's in each 8-bit chunk
    for (int i = 0; i < 32; i++) begin
        reg [7:0] chunk_count;
        chunk_count = 8'd0;
        for (int j = 0; j < 8; j++) begin
            if (in[(i * 8) + j + 1]) begin
                chunk_count = chunk_count + 1'b1;
            end
        end
        
        // Add chunk count to total count
        count = count + chunk_count;
    end
    
    // Handle the last bit
    if (in[0]) begin
        count = count + 1'b1;
    end
    
    // Limit count to 8 bits
    if (count > 255) begin
        out = 8'd255;
    end else begin
        out = count;
    end
end

endmodule