module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_q; // Temporary array to store next states

// Look-up table for Rule 110
reg [7:0] lut [7:0]; // 8 entries for 3-bit combinations

initial begin
    // Initialize the LUT according to Rule 110
    lut[0] = 8'b00000000; // 000 -> 0
    lut[1] = 8'b00000001; // 001 -> 1
    lut[2] = 8'b00000001; // 010 -> 1
    lut[3] = 8'b00000000; // 011 -> 0
    lut[4] = 8'b00000001; // 100 -> 1
    lut[5] = 8'b00000001; // 101 -> 1
    lut[6] = 8'b00000001; // 110 -> 1
    lut[7] = 8'b00000000; // 111 -> 0
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0;
            end else begin
                left = q[i-1];
            end
            center = q[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = q[i+1];
            end
            
            // Use the LUT to determine the next state
            next_q[i] = lut[{left, center, right}];
        end
        q <= next_q; // Update q with calculated next states
    end
end

endmodule