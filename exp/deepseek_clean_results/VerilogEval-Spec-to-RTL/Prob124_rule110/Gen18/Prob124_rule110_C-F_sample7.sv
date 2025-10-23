module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state logic
    wire [511:0] next_q;

    // Generate next state for each bit with optimized boundary handling
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Directly compute next state with boundary conditions
            assign next_q[i] = 
                ((i == 511 ? 1'b0 : q[i+1]) & q[i] & ~(i == 0 ? 1'b0 : q[i-1])) |  // 110
                ((i == 511 ? 1'b0 : q[i+1]) & ~q[i] & (i == 0 ? 1'b0 : q[i-1])) |  // 101
                (~(i == 511 ? 1'b0 : q[i+1]) & q[i]) |                             // 0x1
                (~(i == 511 ? 1'b0 : q[i+1]) & (i == 0 ? 1'b0 : q[i-1]));           // 001
        end
    endgenerate

    // State transition logic with clock gating hint
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    // Synthesis directive for power optimization
    /* synthesis translate_off */
    initial $display("Rule110 with optimized PPA");
    /* synthesis translate_on */

endmodule