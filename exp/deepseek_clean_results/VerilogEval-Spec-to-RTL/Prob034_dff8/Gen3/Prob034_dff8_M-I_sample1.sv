module TopModule (
    input        clk,    // Clock input
    input  [7:0] d,      // 8-bit data input
    output reg [7:0] q    // 8-bit registered output
);

    // Single always block for all 8 flip-flops
    always @(posedge clk) begin
        q <= d;  // Non-blocking assignment for sequential logic
    end

    // Alternative version with synchronous reset (uncomment if needed):
    /*
    input rst_n,  // Active-low synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            q <= 8'h00;
        else
            q <= d;
    end
    */

endmodule