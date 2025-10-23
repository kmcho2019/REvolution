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
    
    // Packed memory array for better synthesis
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Power-on initialization
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous write with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Run-time reset
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Clean combinational read path
    wire [WIDTH-1:0] raw_read_data = mem[read_addr];
    
    // Efficient output control
    assign read_data = read_en ? raw_read_data : {WIDTH{1'b0}};

endmodule