module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Shift q left by 1 bit, inserting 0 at LSB to model q[-1] = 0 boundary
    wire [511:0] left_shifted = {q[510:0], 1'b0};

    // Shift q right by 1 bit, inserting 0 at MSB to model q[512] = 0 boundary
    wire [511:0] right_shifted = {1'b0, q[511:1]};

    // Next state computed as XOR of left and right shifted vectors
    wire [511:0] q_next = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule