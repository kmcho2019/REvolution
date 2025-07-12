module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        center = current_state[i];

        // Apply Rule 110 using a lookup table
        reg [2:0] neighbor_values = {left, center, right};
        reg [7:0] lut[8] = {
            8'b00000000, // 000
            8'b00000001, // 001
            8'b00000001, // 010
            8'b00000000, // 011
            8'b00000001, // 100
            8'b00000001, // 101
            8'b00000001, // 110
            8'b00000000  // 111
        };
        next_state[i] = lut[neighbor_values];
    end
end

assign q = current_state;

endmodule