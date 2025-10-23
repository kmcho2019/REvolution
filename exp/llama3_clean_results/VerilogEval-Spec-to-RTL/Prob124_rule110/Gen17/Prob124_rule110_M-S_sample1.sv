module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Determine the states of the neighbors
        left = (i == 0)? 1'b0 : current_state[i - 1];
        center = current_state[i];
        right = (i == 511)? 1'b0 : current_state[i + 1];
        
        // Simplified calculation of the next state based on Rule 110
        next_state[i] = ~(left & center & right) & (center | right) | (left & ~center & right);
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