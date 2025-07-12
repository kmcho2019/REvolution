module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,  // Explicit 3-bit address for DEPTH=8
    input [5:0] write_data,  // Explicit 6-bit data width
    input read_en,
    input [2:0] read_addr,   // Explicit 3-bit address for DEPTH=8
    output [5:0] read_data   // Note: Now a wire (driven by assign)
);

    // Memory array declaration
    reg [5:0] mem [0:7];  // Fixed size for DEPTH=8
    
    // Synchronous write operation with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            mem[0] <= 6'b0;
            mem[1] <= 6'b0;
            mem[2] <= 6'b0;
            mem[3] <= 6'b0;
            mem[4] <= 6'b0;
            mem[5] <= 6'b0;
            mem[6] <= 6'b0;
            mem[7] <= 6'b0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Combinational read with enable using assign
    assign read_data = read_en ? mem[read_addr] : 6'b0;

endmodule