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
    
    // Main memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Shadow register for write-through functionality
    reg [WIDTH-1:0] shadow_reg;
    reg shadow_valid;
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
        shadow_valid = 1'b0;
    end
    
    // Synchronous write operation with shadow register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            shadow_valid <= 1'b0;
        end
        else begin
            if (write_en) begin
                mem[write_addr] <= write_data;
                // Capture write data in shadow register if address matches read
                if (read_en && (write_addr == read_addr)) begin
                    shadow_reg <= write_data;
                    shadow_valid <= 1'b1;
                end
            end
            else begin
                shadow_valid <= 1'b0;
            end
        end
    end
    
    // Pipelined read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            if (read_en) begin
                // Use shadow register if available, otherwise use memory
                read_data <= shadow_valid ? shadow_reg : mem[read_addr];
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule