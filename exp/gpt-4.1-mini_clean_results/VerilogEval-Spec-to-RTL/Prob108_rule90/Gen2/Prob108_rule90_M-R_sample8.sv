module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Shift q left by 1 with zero padding on LSB side (q[-1] = 0)
    wire [511:0] left_shifted = {q[510:0], 1'b0};

    // Shift q right by 1 with zero padding on MSB side (q[512] = 0)
    wire [511:0] right_shifted = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors
    wire [511:0] next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule