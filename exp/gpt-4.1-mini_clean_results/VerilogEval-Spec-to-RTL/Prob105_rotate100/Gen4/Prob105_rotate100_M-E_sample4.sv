module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Compute left rotation by one bit
    wire [99:0] rotate_left;
    // Compute right rotation by one bit
    wire [99:0] rotate_right;

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : ROTATE_BITS
            // Left rotate: bit i = q[(i+1) mod 100]
            assign rotate_left[i]  = q[(i+1) % 100];
            // Right rotate: bit i = q[(i-1+100) mod 100]
            assign rotate_right[i] = q[(i + 99) % 100];
        end
    endgenerate

    // Select next value to load into register q
    wire [99:0] next_q;
    // Multiplexer for rotation control (2'b00 or 2'b11: no rotation)
    wire rotate_enable = (ena == 2'b01) || (ena == 2'b10);

    assign next_q = load ? data : 
                    (ena == 2'b01) ? rotate_right :
                    (ena == 2'b10) ? rotate_left  :
                                     q;       // No rotation

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule