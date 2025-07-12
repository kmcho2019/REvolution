module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;

always @(*) begin
    for (i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) begin
            left = 0;
            center = current_state[i];
            right = i == 511 ? 0 : current_state[i + 1];
        end else if (i == 511) begin
            left = current_state[i - 1];
            center = current_state[i];
            right = 0;
        end else begin
            left = current_state[i - 1];
            center = current_state[i];
            right = current_state[i + 1];
        end
        
        reg [1:0] left_center = {left, center};
        next_state[i] = (left_center == 2'b00 || left_center == 2'b01 || left_center == 2'b10) ? (right ? 1'b1 : 1'b0) : (left ? 1'b0 : 1'b1);
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