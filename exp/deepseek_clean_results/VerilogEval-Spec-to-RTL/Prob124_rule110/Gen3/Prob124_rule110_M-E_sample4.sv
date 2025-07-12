module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Shift registers for neighbor alignment
    reg [511:0] left_neighbor;
    reg [511:0] right_neighbor;

    // Combinational next state calculation
    wire [511:0] next_q;

    // Create padded neighbor registers
    always @(*) begin
        left_neighbor = {q[510:0], 1'b0};  // q[i+1] with 0 at MSB
        right_neighbor = {1'b0, q[511:1]}; // q[i-1] with 0 at LSB
    end

    // Parallel Rule 110 implementation using bitwise operations
    assign next_q = (~left_neighbor & (q | right_neighbor)) | 
                   (left_neighbor & q & ~right_neighbor);

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule