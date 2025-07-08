module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of one cell according to Rule 110
    // Inputs: left, center, right bits
    // The rule is encoded as per the truth table:
    // Next = (L & C & ~R) | (L & ~C & R) | (~L & C & R) | (~L & C & ~R) | (~L & ~C & R)
    // Simplified from the table given.
    function rule110;
        input left, center, right;
        begin
            rule110 = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right);
        end
    endfunction

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each bit
            for (i = 0; i < 512; i = i + 1) begin
                // define neighbors with boundary = 0
                // left = q[i+1] if i < 511 else 0
                // right = q[i-1] if i > 0 else 0
                next_state[i] <= rule110(
                    (i < 511) ? q[i+1] : 1'b0,
                    q[i],
                    (i > 0) ? q[i-1] : 1'b0
                );
            end
            q <= next_state;
        end
    end

endmodule