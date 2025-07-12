module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Lookup table for Rule 110
reg [7:0] lut[2**3-1:0];

initial begin
    lut[0] = 4'b0000; // 000
    lut[1] = 4'b0000; // 001
    lut[2] = 4'b0100; // 010
    lut[3] = 4'b0100; // 011
    lut[4] = 4'b1000; // 100
    lut[5] = 4'b0100; // 101
    lut[6] = 4'b0100; // 110
    lut[7] = 4'b0000; // 111
end

integer i;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg [2:0] input;
        reg left, center, right;
        
        // Handle boundary conditions
        left = (i == 0) ? 1'b0 : current_state[i-1];
        center = current_state[i];
        right = (i == 511) ? 1'b0 : current_state[i+1];
        
        // Create input for LUT
        input = {left, center, right};
        
        // Apply Rule 110 logic using LUT
        next_state[i] = lut[input];
    end
end

assign q = current_state;

endmodule