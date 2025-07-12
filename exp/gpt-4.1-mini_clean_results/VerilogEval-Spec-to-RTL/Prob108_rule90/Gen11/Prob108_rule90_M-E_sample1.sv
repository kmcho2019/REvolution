module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Shift q left by 1 bit, inserting 0 at LSB (boundary condition)
    assign left_shifted = {q[510:0], 1'b0};

    // Shift q right by 1 bit, inserting 0 at MSB (boundary condition)
    assign right_shifted = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors for each bit
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule