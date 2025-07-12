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
genvar i;
generate
    for (i = 0; i < NUM_CELLS; i++) begin
        // Left and right neighbor signals
        wire left, right;
        
        // Boundary conditions
        if (i == 0) begin
            assign left = 1'b0;
            assign right = q_reg[i + 1];
        end else if (i == NUM_CELLS - 1) begin
            assign left = q_reg[i - 1];
            assign right = 1'b0;
        end else begin
            assign left = q_reg[i - 1];
            assign right = q_reg[i + 1];
        end
        
        // Compute next state using XOR of neighbors
        wire next_state;
        assign next_state = left ^ right;
        
        // Update q_reg based on load and calculated next states
        always @(posedge clk) begin
            if (load) begin
                q_reg[i] <= data[i]; // Load input data
            end else begin
                q_reg[i] <= next_state; // Update with calculated next state
            end
        end
    end
endgenerate

// Output the current state
assign q = q_reg;

endmodule