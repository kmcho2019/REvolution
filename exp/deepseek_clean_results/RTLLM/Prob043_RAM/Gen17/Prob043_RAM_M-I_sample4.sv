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
    parameter PIPELINE_OUT = 0; // Set to 1 for pipelined output
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Optional synchronous reset if needed
        end else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Synchronous read operation
    generate
        if (PIPELINE_OUT) begin
            // Pipelined output version
            reg [WIDTH-1:0] read_data_reg;
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data_reg <= {WIDTH{1'b0}};
                    read_data <= {WIDTH{1'b0}};
                end else begin
                    if (read_en)
                        read_data_reg <= mem[read_addr];
                    read_data <= read_data_reg;
                end
            end
        end else begin
            // Non-pipelined version
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data <= {WIDTH{1'b0}};
                end else if (read_en) begin
                    read_data <= mem[read_addr];
                end
            end
        end
    endgenerate

endmodule