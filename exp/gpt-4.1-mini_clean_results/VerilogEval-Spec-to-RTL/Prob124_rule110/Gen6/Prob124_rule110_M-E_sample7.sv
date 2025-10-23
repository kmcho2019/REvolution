module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal state with padding for boundaries (index 0 and 513 are always 0)
    reg [513:0] state;      // state[1:512] are actual cells; state[0] and state[513] are boundary zeros

    integer i;
    reg [513:0] next_state;

    always @(*) begin
        // Boundary zeros at both ends
        next_state[0] = 1'b0;
        next_state[513] = 1'b0;

        // Compute next state for each cell in 1..512 based on neighbors at state[i+1], state[i], state[i-1]
        // Rule 110: next = (~left & center) | (center ^ right)
        for (i = 1; i <= 512; i = i + 1) begin
            wire left = state[i + 1];
            wire center = state[i];
            wire right = state[i - 1];
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            // Load data into internal state with zero boundaries
            state[0] <= 1'b0;
            state[513] <= 1'b0;
            state[512:1] <= data;
        end else begin
            state <= next_state;
        end

        // Output current 512 cells
        q <= state[512:1];
    end

endmodule