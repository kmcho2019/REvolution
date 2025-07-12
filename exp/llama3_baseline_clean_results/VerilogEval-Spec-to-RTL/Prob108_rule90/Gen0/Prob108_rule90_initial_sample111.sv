module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to hold the current state of the system

// Load data into the register when load is high
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Calculate next state for each cell
        for (int i = 0; i < 512; i++) begin
            // Handle boundary conditions
            reg left, right;
            if (i == 0) begin
                left = 0; // Left boundary is always 0
            end else begin
                left = q_reg[i-1];
            end
            
            if (i == 511) begin
                right = 0; // Right boundary is always 0
            end else begin
                right = q_reg[i+1];
            end
            
            // Update the next state of the cell
            q_reg[i] <= left ^ right;
        end
    end
end

// Assign the output
assign q = q_reg;

endmodule