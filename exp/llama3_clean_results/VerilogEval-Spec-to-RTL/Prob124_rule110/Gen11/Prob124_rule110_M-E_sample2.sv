module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        reg [511:0] left, center, right, next_state;
        center = current_state;
        left = {1'b0, current_state[511:1]};
        right = {current_state[510:0], 1'b0};
        
        next_state = ~(left & center & right) & (left | center | right);
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule