module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

// Define a parameter for the number of cells
parameter NUM_CELLS = 512;

// Register to store the current state of each cell
reg [NUM_CELLS-1:0] q_reg;

// Systolic array processing elements
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        for (int i = 0; i < NUM_CELLS; i++) begin
            reg left, right;
            // Boundary conditions
            if (i == 0) begin
                left = 1'b0;
                right = q_reg[i + 1];
            end else if (i == NUM_CELLS - 1) begin
                left = q_reg[i - 1];
                right = 1'b0;
            end else begin
                left = q_reg[i - 1];
                right = q_reg[i + 1];
            end
            
            // Compute next state using XOR of neighbors
            q_reg[i] <= left ^ right;
        end
    end
end

// Output the current state
assign q = q_reg;

endmodule