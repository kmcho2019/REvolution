module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Systolic array cells
reg [511:0] cell_state;

always @(posedge clk) begin
    if (load) begin
        // Load initial state into systolic array
        cell_state <= data;
    end else begin
        // Calculate next state of each cell in systolic array
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Handle first cell (left neighbor is 0)
                cell_state[i] <= cell_state[i+1];
            end else if (i == 511) begin
                // Handle last cell (right neighbor is 0)
                cell_state[i] <= cell_state[i-1];
            end else begin
                // Calculate next state of cell based on XOR of left and right neighbors
                cell_state[i] <= cell_state[i-1] ^ cell_state[i+1];
            end
        end
        q_reg <= cell_state;
    end
end

assign q = q_reg;

endmodule