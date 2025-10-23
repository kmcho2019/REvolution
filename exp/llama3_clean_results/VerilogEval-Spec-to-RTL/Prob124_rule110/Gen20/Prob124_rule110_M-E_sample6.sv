module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Lookup tables for Rule 110
reg [1:0] lut_0 [3:0], lut_1 [3:0];

initial begin
    // Initialize lookup tables for Rule 110
    lut_0[0] = 2'b00; // 000
    lut_0[1] = 2'b00; // 001
    lut_0[2] = 2'b01; // 010
    lut_0[3] = 2'b00; // 011
    lut_0[4] = 2'b00; // 100
    lut_0[5] = 2'b00; // 101
    lut_0[6] = 2'b01; // 110
    lut_0[7] = 2'b00; // 111
    
    lut_1[0] = 2'b00; // 000
    lut_1[1] = 2'b01; // 001
    lut_1[2] = 2'b01; // 010
    lut_1[3] = 2'b01; // 011
    lut_1[4] = 2'b01; // 100
    lut_1[5] = 2'b01; // 101
    lut_1[6] = 2'b01; // 110
    lut_1[7] = 2'b00; // 111
end

// Combinational logic to compute the next state
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg [1:0] left, right;
        
        // Determine the states of the neighbors
        left = (i == 0)? 2'b00 : {current_state[i - 1], 1'b0};
        right = (i == 511)? 2'b00 : {1'b0, current_state[i + 1]};
        
        // Use the lookup tables to compute the next state
        if (current_state[i] == 1'b0) begin
            next_state[i] = lut_0[{left[1], right[0]}];
        end else begin
            next_state[i] = lut_1[{left[1], right[0]}];
        end
    end
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule