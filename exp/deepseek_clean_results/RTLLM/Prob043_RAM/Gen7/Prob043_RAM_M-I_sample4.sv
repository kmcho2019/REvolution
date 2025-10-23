module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    parameter PIPELINE_READ = 0;  // Optional pipeline register for read
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] read_data_reg;
    
    // Reset operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Let synthesis handle memory initialization
            // Reset will be implemented according to target technology
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    generate
        if (PIPELINE_READ) begin
            // Pipelined read operation
            always @(posedge clk) begin
                if (read_en) begin
                    read_data_reg <= mem[read_addr];
                end
                read_data <= read_data_reg;
            end
        end else begin
            // Combinational read operation
            always @(*) begin
                if (read_en) begin
                    read_data = mem[read_addr];
                end
                // Maintain previous value when not enabled (reduces switching)
            end
        end
    endgenerate

endmodule