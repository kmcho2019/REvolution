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
        left = (i == 0)? 1'b0 : current_state[i-1];
        center = current_state[i];
        right = (i == 511)? 1'b0 : current_state[i+1];
        
        // Apply Rule 110 logic directly from the table
        if (left == 1'b1 && center == 1'b1 && right == 1'b1) begin
            next_state[i] = 1'b0;
        end else if (left == 1'b1 && center == 1'b1 && right == 1'b0) begin
            next_state[i] = 1'b1;
        end else if (left == 1'b1 && center == 1'b0 && right == 1'b1) begin
            next_state[i] = 1'b1;
        end else if (left == 1'b1 && center == 1'b0 && right == 1'b0) begin
            next_state[i] = 1'b0;
        end else if (left == 1'b0 && center == 1'b1 && right == 1'b1) begin
            next_state[i] = 1'b1;
        end else if (left == 1'b0 && center == 1'b1 && right == 1'b0) begin
            next_state[i] = 1'b1;
        end else if (left == 1'b0 && center == 1'b0 && right == 1'b1) begin
            next_state[i] = 1'b1;
        end else begin // left == 1'b0 && center == 1'b0 && right == 1'b0
            next_state[i] = 1'b0;
        end
    end
end

assign q = current_state;

endmodule