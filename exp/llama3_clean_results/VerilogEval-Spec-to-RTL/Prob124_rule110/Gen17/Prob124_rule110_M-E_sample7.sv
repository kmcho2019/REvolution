module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

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
        reg left, center, right, left_and_center, left_and_not_center, not_left_and_center, not_left_and_not_center;
        reg temp1, temp2;
        
        // Handle boundary conditions
        left = (i == 0) ? 1'b0 : current_state[i-1];
        center = current_state[i];
        right = (i == 511) ? 1'b0 : current_state[i+1];
        
        // Compute the next state based on Rule 110
        left_and_center = left & center;
        left_and_not_center = left & ~center;
        not_left_and_center = ~left & center;
        not_left_and_not_center = ~left & ~center;
        
        temp1 = (left_and_center & ~right) | (left_and_not_center & right) | (not_left_and_center) | (not_left_and_not_center & right);
        next_state[i] = ~temp1;
    end
end

assign q = current_state;

endmodule