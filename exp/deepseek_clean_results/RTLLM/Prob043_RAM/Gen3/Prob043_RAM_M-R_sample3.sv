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
    
    // Initialize memory (synthesis will ignore this in hardware)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset handled in initial block for simulation
            // In hardware, FPGA/ASIC tools will handle initialization
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation (combinational)
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};

endmodule