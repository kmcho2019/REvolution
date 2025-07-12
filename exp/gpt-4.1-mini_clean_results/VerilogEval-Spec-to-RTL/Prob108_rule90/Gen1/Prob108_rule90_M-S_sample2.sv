module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Shift q left by 1, zero-extend LSB
    wire [511:0] left_shift = {q[510:0], 1'b0};
    // Shift q right by 1, zero-extend MSB
    wire [511:0] right_shift = {1'b0, q[511:1]};

    assign next_q = left_shift ^ right_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule