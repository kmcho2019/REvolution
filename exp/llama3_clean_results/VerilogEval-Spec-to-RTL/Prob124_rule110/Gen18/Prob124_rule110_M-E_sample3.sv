module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

// Define the number of cells
parameter NUM CELLS = 512;

// Internal signals
reg [NUM CELLS-1:0] current_state;
reg [NUM CELLS-1:0] next_state;

// Combinational logic to compute the next state
always @(*) begin
    for (int i = 0; i < NUM CELLS; i++) begin
        reg left, center, right;
        
        // Determine the states of the neighbors
        left = (i == 0)? 1'b0 : current_state[i - 1];
        center = current_state[i];
        right = (i == NUM CELLS - 1)? 1'b0 : current_state[i + 1];
        
        // Compute the next state directly based on Rule 110
        if ((left == 1'b1 && center == 1'b1 && right == 1'b1) ||
            (left == 1'b0 && center == 1'b0 && right == 1'b0) ||
            (left == 1'b1 && center == 1'b0 && right == 1'b0) ||
            (left == 1'b0 && center == 1'b1 && right == 1'b0) ||
            (left == 1'b0 && center == 1'b0 && right == 1'b0)) begin
            next_state[i] = 1'b0;
        end else begin
            next_state[i] = 1'b1;
        end
    end
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule