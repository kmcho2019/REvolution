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
    next_state = 0;
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        
        center = current_state[i];
        
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        
        // Apply Rule 110 logic
        if ((left == 1'b1 && center == 1'b1 && right == 1'b1) || 
            (left == 1'b1 && center == 1'b1 && right == 1'b0) || 
            (left == 1'b1 && center == 1'b0 && right == 1'b1) || 
            (left == 1'b1 && center == 1'b0 && right == 1'b0) || 
            (left == 1'b0 && center == 1'b1 && right == 1'b1) || 
            (left == 1'b0 && center == 1'b1 && right == 1'b0) || 
            (left == 1'b0 && center == 1'b0 && right == 1'b1)) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
end

assign q = current_state;

endmodule