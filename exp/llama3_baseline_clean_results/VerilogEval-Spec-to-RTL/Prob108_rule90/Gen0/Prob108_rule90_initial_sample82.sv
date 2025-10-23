module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Calculate the next state of each cell
reg [511:0] next_q;

always @(*) begin
    // Initialize the next state of each cell
    next_q = 0;

    // Calculate the next state of each cell
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;

        // Assume the boundaries are zero
        if (i == 0) begin
            left = 0;
        end else begin
            left = q[i - 1];
        end

        center = q[i];

        if (i == 511) begin
            right = 0;
        end else begin
            right = q[i + 1];
        end

        // Apply Rule 90
        next_q[i] = left ^ right;
    end
end

// Update the register with the new state at each clock cycle
always @(posedge clk) begin
    if (load) begin
        // Load the data into the register
        q <= data;
    end else begin
        // Update the register with the new state
        q <= next_q;
    end
end

endmodule