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
        wire left, center, right;
        
        // Handle boundary conditions
        assign left = (i == 0) ? 1'b0 : current_state[i-1];
        assign center = current_state[i];
        assign right = (i == 511) ? 1'b0 : current_state[i+1];
        
        // Apply Rule 110 logic
        wire left_and_center_and_right = left & center & right;
        wire left_and_center_and_not_right = left & center & ~right;
        wire left_and_not_center_and_right = left & ~center & right;
        wire left_and_not_center_and_not_right = left & ~center & ~right;
        wire not_left_and_center_and_right = ~left & center & right;
        wire not_left_and_center_and_not_right = ~left & center & ~right;
        wire not_left_and_not_center_and_right = ~left & ~center & right;
        wire not_left_and_not_center_and_not_right = ~left & ~center & ~right;
        
        assign next_state[i] = (left_and_center_and_not_right | 
                               left_and_not_center_and_right | 
                               left_and_not_center_and_not_right | 
                               not_left_and_center_and_right | 
                               not_left_and_center_and_not_right | 
                               not_left_and_not_center_and_right | 
                               not_left_and_not_center_and_not_right);
    end
end

assign q = current_state;

endmodule