module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end
end

// Separate always block for the update operation
always @(posedge clk) begin
    if (!load) begin
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            // Apply Rule 90 logic directly
            // Since each cell only depends on its immediate neighbors
            reg left, center, right;
            assign left = (i == 0) ? 1'b0 : q_reg[i - 1];
            assign center = q_reg[i];
            assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
            
            // Calculate the next state of the cell using Rule 90
            reg next_cell;
            assign next_cell = (left ^ right);
            next_state[i] = next_cell;
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule