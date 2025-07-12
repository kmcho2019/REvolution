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
    
    // Memory initialization using generate
    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : INIT
            initial mem[i] = {WIDTH{1'b0}};
        end
    endgenerate
    
    // Clock-gated write operation
    wire [WIDTH-1:0] next_mem [0:DEPTH-1];
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : WRITE
            assign next_mem[i] = (write_en && (write_addr == i)) ? 
                                write_data : mem[i];
        end
    endgenerate
    
    // Synchronous update of memory
    always @(posedge clk) begin
        for (integer j = 0; j < DEPTH; j = j + 1)
            mem[j] <= next_mem[j];
    end
    
    // Combinational read with enable control
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};

endmodule