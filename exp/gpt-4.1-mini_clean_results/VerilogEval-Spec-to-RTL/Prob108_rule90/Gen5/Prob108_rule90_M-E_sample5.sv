module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_left_shift;
    wire [511:0] q_right_shift;
    wire [511:0] q_next;

    // Left shift by 1 with zero padding at LSB
    assign q_left_shift = {q[510:0], 1'b0};
    // Right shift by 1 with zero padding at MSB
    assign q_right_shift = {1'b0, q[511:1]};
    // Next state is XOR of left and right neighbors
    assign q_next = q_left_shift ^ q_right_shift;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule