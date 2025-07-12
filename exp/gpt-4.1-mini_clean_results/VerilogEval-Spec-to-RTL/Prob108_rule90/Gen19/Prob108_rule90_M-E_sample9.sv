module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Shift left by 1 with zero boundary on LSB side
    assign left_shifted  = {q[510:0], 1'b0};
    // Shift right by 1 with zero boundary on MSB side
    assign right_shifted = {1'b0, q[511:1]};

    // next_state bit i = q[i-1] XOR q[i+1], with boundaries zero
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule