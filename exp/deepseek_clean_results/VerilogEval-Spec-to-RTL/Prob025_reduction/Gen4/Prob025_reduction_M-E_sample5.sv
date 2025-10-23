module TopModule (
    input [7:0] in,       // 8-bit input data
    output reg parity     // Registered even parity bit
);
    parameter WIDTH = 8;
    
    // First stage: XOR lower and upper nibbles separately
    wire [1:0] stage1_out;
    assign stage1_out[0] = ^in[3:0];  // Lower nibble
    assign stage1_out[1] = ^in[7:4];  // Upper nibble
    
    /* Optional pipeline register - uncomment for pipelined version
    reg [1:0] stage1_reg;
    always @(posedge clk) begin
        stage1_reg <= stage1_out;
    end
    */
    
    // Second stage: Combine the partial results
    wire final_parity = ^stage1_out;  // Or use stage1_reg for pipelined version
    
    // Output register
    always @(*) begin
        parity = final_parity;
    end
endmodule