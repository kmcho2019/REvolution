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
    
    // Combinational read with enable gate
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Write operation with generate-based reset
    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : mem_init
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    mem[i] <= {WIDTH{1'b0}};
                end
                else if (write_en && (write_addr == i)) begin
                    mem[i] <= write_data;
                end
            end
        end
    endgenerate

endmodule