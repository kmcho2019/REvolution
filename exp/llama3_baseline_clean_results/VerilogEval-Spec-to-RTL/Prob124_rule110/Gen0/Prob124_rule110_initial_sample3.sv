module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational logic to compute next state
    reg [511:0] next_state;

    always @* begin
        // Apply Rule 110 to compute the next state of each cell
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            
            // Handle boundary conditions
            if (i == 0) begin
                left = 0;
                center = q[i];
                right = q[i + 1];
            end else if (i == 511) begin
                left = q[i - 1];
                center = q[i];
                right = 0;
            end else begin
                left = q[i - 1];
                center = q[i];
                right = q[i + 1];
            end
            
            // Apply Rule 110
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
            end else if (left == 1'b0 && center == 1'b0 && right == 1'b0) begin
                next_state[i] = 1'b0;
            end
        end
    end

    // Sequential logic to update state on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule