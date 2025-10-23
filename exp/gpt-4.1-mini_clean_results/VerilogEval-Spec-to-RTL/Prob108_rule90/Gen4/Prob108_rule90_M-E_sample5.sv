module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] shifted_left;
    wire [511:0] shifted_right;
    wire [511:0] next_state;

    // Shift q left by 1, LSB filled with 0
    assign shifted_left = {q[510:0], 1'b0};
    // Shift q right by 1, MSB filled with 0
    assign shifted_right = {1'b0, q[511:1]};

    // Next state is XOR of neighbors
    assign next_state = shifted_left ^ shifted_right;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule