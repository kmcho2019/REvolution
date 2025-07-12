module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Define left neighbors with zero boundary at bit -1
    assign left_neighbors = {1'b0, q[511:1]};
    // Define right neighbors with zero boundary at bit 512
    assign right_neighbors = {q[510:0], 1'b0};
    // Next state: XOR of left and right neighbors per Rule 90
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule