module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] shifted_left;
    wire [511:0] shifted_right;
    wire [511:0] next_state;

    // Shift left by 1 with zero padded on LSB
    assign shifted_left  = {q[510:0], 1'b0};
    // Shift right by 1 with zero padded on MSB
    assign shifted_right = {1'b0, q[511:1]};

    assign next_state = shifted_left ^ shifted_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule