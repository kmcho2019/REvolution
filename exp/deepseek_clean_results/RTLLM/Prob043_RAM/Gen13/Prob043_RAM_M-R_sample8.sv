module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize all memory locations to 0
    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin: INIT
            initial mem[i] = {WIDTH{1'b0}};
        end
    endgenerate
    
    // Combinational read with enable
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Clock-gated write operation
    wire write_clk = clk & write_en;
    always @(posedge write_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Optional synchronous reset if needed
        end else begin
            mem[write_addr] <= write_data;
        end
    end

endmodule