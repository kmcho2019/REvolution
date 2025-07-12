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
    
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] read_reg;
    
    // Memory initialization and write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem[0] <= 0;
            mem[1] <= 0;
            mem[2] <= 0;
            mem[3] <= 0;
            mem[4] <= 0;
            mem[5] <= 0;
            mem[6] <= 0;
            mem[7] <= 0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_reg <= 0;
        end
        else if (read_en) begin
            read_reg <= mem[read_addr];
        end
        else begin
            read_reg <= 0;
        end
    end
    
    assign read_data = read_reg;

endmodule