module TopModule(
    input  [254:0] in, 
    output [7:0] out
);

// Initialize variables to hold the counts
reg [7:0] count;

// Calculate the population count
always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 32; i++) begin
        reg [7:0] byte_count;
        byte_count = 8'd0;
        for (int j = 0; j < 8; j++) begin
            byte_count = byte_count + in[i*8 + j];
        end
        count = count + byte_count;
    end
    // Count the last 7 bits
    for (int i = 0; i < 7; i++) begin
        count = count + in[255 - i];
    end
    out = count;
end

endmodule