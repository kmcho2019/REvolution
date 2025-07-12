module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the lookup table for the Rule 110 automaton
reg [1:0] lut[2:0][2:0][2:0];
initial begin
    lut[0][0][0] = 2'b00;
    lut[0][0][1] = 2'b00;
    lut[0][1][0] = 2'b01;
    lut[0][1][1] = 2'b01;
    lut[1][0][0] = 2'b00;
    lut[1][0][1] = 2'b01;
    lut[1][1][0] = 2'b01;
    lut[1][1][1] = 2'b00;
end

// Combinational logic to compute the next state
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Determine the states of the neighbors
        left = (i == 0)? current_state[511] : current_state[i - 1];
        center = current_state[i];
        right = (i == 511)? current_state[0] : current_state[i + 1];
        
        // Use the lookup table to compute the next state
        next_state[i] = lut[left][center][right][0];
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