module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left;   // q[i+1], left neighbor with zero at MSB boundary
    wire [511:0] right;  // q[i-1], right neighbor with zero at LSB boundary
    wire [511:0] next_state;

    // Shift left by 1 to get left neighbors; MSB zero due to boundary
    assign left = {q[510:0], 1'b0};

    // Shift right by 1 to get right neighbors; LSB zero due to boundary
    assign right = {1'b0, q[511:1]};

    // next_state = (~left & center) | (center ^ right);
    // center = q
    assign next_state = ((~left) & q) | (q ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule