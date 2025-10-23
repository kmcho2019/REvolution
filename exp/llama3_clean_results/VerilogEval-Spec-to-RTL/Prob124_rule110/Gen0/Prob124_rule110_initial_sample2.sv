module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to hold the current state of the system
assign q = q_reg; // Continuous assignment to output the current state

always @(posedge clk) begin
    if (load) begin
        // Load data into the system when load is high
        q_reg <= data;
    end else begin
        // Calculate and load the next state of the system according to Rule 110
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0; // Boundary condition: left of the first cell is always 0
                center = q_reg[i];
                right = q_reg[i + 1];
            end else if (i == 511) begin
                left = q_reg[i - 1];
                center = q_reg[i];
                right = 0; // Boundary condition: right of the last cell is always 0
            end else begin
                left = q_reg[i - 1];
                center = q_reg[i];
                right = q_reg[i + 1];
            end
            
            // Apply Rule 110
            if (left && center && right) begin
                next_state[i] = 0;
            end else if (left && center &&!right) begin
                next_state[i] = 1;
            end else if (left &&!center && right) begin
                next_state[i] = 1;
            end else if (left &&!center &&!right) begin
                next_state[i] = 0;
            end else if (!left && center && right) begin
                next_state[i] = 1;
            end else if (!left && center &&!right) begin
                next_state[i] = 1;
            end else if (!left &&!center && right) begin
                next_state[i] = 1;
            end else if (!left &&!center &&!right) begin
                next_state[i] = 0;
            end
        end
        q_reg <= next_state;
    end
end

endmodule