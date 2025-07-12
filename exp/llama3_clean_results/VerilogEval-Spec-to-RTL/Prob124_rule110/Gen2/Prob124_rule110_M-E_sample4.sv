module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the LUT for Rule 110
reg [1:0] lut [7:0];

always @(*) begin
    lut[0] = 2'b00; // 000
    lut[1] = 2'b00; // 001
    lut[2] = 2'b01; // 010
    lut[3] = 2'b01; // 011
    lut[4] = 2'b01; // 100
    lut[5] = 2'b01; // 101
    lut[6] = 2'b00; // 110
    lut[7] = 2'b00; // 111
end

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbors;
        if (i == 0) begin
            neighbors = {1'b0, current_state[i], current_state[i + 1]};
        end else if (i == 511) begin
            neighbors = {current_state[i - 1], current_state[i], 1'b0};
        end else begin
            neighbors = {current_state[i - 1], current_state[i], current_state[i + 1]};
        end
        
        next_state[i] = lut[neighbors];
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule