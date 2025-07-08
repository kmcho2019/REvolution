module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    integer i;
    reg [511:0] next_state;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Fetch neighbors with boundary conditions
            // left = q[i+1], center = q[i], right = q[i-1]
            // If out of range, treat as 0
            reg left, center, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i-1];

            // Determine next state according to Rule 110
            // Rule 110 can be implemented by a truth table or formula:
            // next = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right);
            // From the table, the pattern produces 1 for all cases except 111,100,000

            // Apply the rule directly:
            next_state[i] = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
endmodule