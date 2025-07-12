module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Combinational logic to calculate the next state of each cell
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        // Calculate the next state of each cell based on its neighbors
        // Left neighbor is 0 for the first cell
        reg left, center, right;
        if (i == 0) begin
            left = 0;
            center = q[i];
            right = q[i + 1];
        end
        // Right neighbor is 0 for the last cell
        else if (i == 511) begin
            left = q[i - 1];
            center = q[i];
            right = 0;
        end
        // For other cells, get neighbors normally
        else begin
            left = q[i - 1];
            center = q[i];
            right = q[i + 1];
        end
        
        // Apply Rule 90
        if (left == 1'b1 && center == 1'b1 && right == 1'b1) begin
            q[i] <= 1'b0;
        end
        else if (left == 1'b1 && center == 1'b1 && right == 1'b0) begin
            q[i] <= 1'b1;
        end
        else if (left == 1'b1 && center == 1'b0 && right == 1'b1) begin
            q[i] <= 1'b0;
        end
        else if (left == 1'b1 && center == 1'b0 && right == 1'b0) begin
            q[i] <= 1'b1;
        end
        else if (left == 1'b0 && center == 1'b1 && right == 1'b1) begin
            q[i] <= 1'b1;
        end
        else if (left == 1'b0 && center == 1'b1 && right == 1'b0) begin
            q[i] <= 1'b0;
        end
        else if (left == 1'b0 && center == 1'b0 && right == 1'b1) begin
            q[i] <= 1'b1;
        end
        else if (left == 1'b0 && center == 1'b0 && right == 1'b0) begin
            q[i] <= 1'b0;
        end
    end
end

// Sequential logic to update the register at each clock cycle
always @(posedge clk) begin
    if (load) begin
        q <= data; // Load new data when load is high
    end
    else begin
        // Update q based on the calculated next state
        // Note: The always @(*) block already calculates the next state
        //       and updates q. So, we don't need to do anything here.
    end
end

endmodule