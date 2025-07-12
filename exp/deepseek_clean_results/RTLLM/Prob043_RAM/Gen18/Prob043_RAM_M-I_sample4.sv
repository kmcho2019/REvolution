module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [$clog2(DEPTH)-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    integer i;
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Pipelined read operation
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= 0;
        end
        else if (read_en) begin
            read_data <= mem[read_addr];
        end
        else begin
            read_data <= 0;
        end
    end

endmodule