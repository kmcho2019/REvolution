module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    
    // Optimized Rule 90 logic with concatenation-based boundaries
    assign next_q = {1'b0, q[511:1]} ^ {q[510:0], 1'b0};
    
    // Single synchronous update block
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule