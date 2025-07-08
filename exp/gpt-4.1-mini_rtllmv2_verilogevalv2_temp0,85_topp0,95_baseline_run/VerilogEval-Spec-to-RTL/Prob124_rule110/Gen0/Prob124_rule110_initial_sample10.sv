module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next cell state according to Rule 110
    // Inputs: left, center, right
    // Returns: next center state bit
    function automatic bit rule110_bit(input bit left, input bit center, input bit right);
        begin
            // Rule 110 truth table as per problem statement:
            // left center right | next
            //  1    1     1     | 0
            //  1    1     0     | 1
            //  1    0     1     | 1
            //  1    0     0     | 0
            //  0    1     1     | 1
            //  0    1     0     | 1
            //  0    0     1     | 1
            //  0    0     0     | 0
            if      (left && center && right) rule110_bit = 1'b0;
            else if (left && center && ~right) rule110_bit = 1'b1;
            else if (left && ~center && right) rule110_bit = 1'b1;
            else if (left && ~center && ~right) rule110_bit = 1'b0;
            else if (~left && center && right) rule110_bit = 1'b1;
            else if (~left && center && ~right) rule110_bit = 1'b1;
            else if (~left && ~center && right) rule110_bit = 1'b1;
            else /* ~left && ~center && ~right */ rule110_bit = 1'b0;
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            bit left = (i == 511) ? 1'b0 : q[i+1];
            bit center = q[i];
            bit right = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = rule110_bit(left, center, right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule