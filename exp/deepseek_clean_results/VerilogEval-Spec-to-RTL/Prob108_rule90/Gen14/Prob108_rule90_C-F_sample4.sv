module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0};
    
    // Combinational Rule 90 logic with optimized boundary handling
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            assign next_q[i] = extended_q[i+1] ^ extended_q[i+2];
        end
    endgenerate
    
    // Synchronous update with load priority
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule