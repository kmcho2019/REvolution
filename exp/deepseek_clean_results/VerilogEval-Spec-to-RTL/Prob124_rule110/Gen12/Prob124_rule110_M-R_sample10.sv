module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state calculation using Boolean algebra for Rule 110
    // Rule 110 can be expressed as: next = (center & (left | right)) | (~center & right)
    wire [511:0] next_q;

    // Left neighbors (q[i+1] with boundary condition)
    wire [511:0] left_neighbor = {q[510:0], 1'b0};
    
    // Right neighbors (q[i-1] with boundary condition)
    wire [511:0] right_neighbor = {1'b0, q[511:1]};

    // Compute next state using optimized Boolean expression
    assign next_q = (q & (left_neighbor | right_neighbor)) | (~q & right_neighbor);

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule