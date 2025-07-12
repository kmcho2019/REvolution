module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    
    // Efficient neighbor selection using concatenation
    wire [511:0] left_neighbors = {1'b0, q[511:1]};
    wire [511:0] right_neighbors = {q[510:0], 1'b0};
    
    // Parallel Rule 90 computation
    assign next_q = left_neighbors ^ right_neighbors;
    
    // Synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule