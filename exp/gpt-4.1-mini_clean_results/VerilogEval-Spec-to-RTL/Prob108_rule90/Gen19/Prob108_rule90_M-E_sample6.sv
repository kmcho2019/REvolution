module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] shifted_left;
    wire [511:0] shifted_right;
    wire [511:0] next_state;

    // Shift left by 1 bit with zero padding on LSB side
    assign shifted_left = {q[510:0], 1'b0};
    // Shift right by 1 bit with zero padding on MSB side
    assign shifted_right = {1'b0, q[511:1]};

    // Rule 90 next state: XOR of left and right neighbors
    assign next_state = shifted_left ^ shifted_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule