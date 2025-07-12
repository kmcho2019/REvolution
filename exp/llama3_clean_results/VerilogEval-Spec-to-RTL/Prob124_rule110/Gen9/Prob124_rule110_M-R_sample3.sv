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
        
        // Apply Rule 110 logic using Karnaugh map
        next_state[i] = (left && center && !right) || 
                        (left && !center && right) || 
                        (!left && center && right) || 
                        (!left && center && !right) || 
                        (!left && !center && right);
    end
end

assign q = current_state;

endmodule