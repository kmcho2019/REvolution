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
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Gray-coded address registers
    reg [2:0] write_addr_gray;
    reg [2:0] read_addr_gray;
    
    // Pipeline registers
    reg [5:0] read_data_pipe;
    reg read_valid_pipe;
    
    // Binary to Gray conversion
    function [2:0] bin2gray;
        input [2:0] bin;
        begin
            bin2gray = {bin[2], bin[2:1] ^ bin[1:0]};
        end
    endfunction
    
    // Memory initialization and write operation
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            write_addr_gray <= 3'b0;
        end
        else begin
            write_addr_gray <= bin2gray(write_addr);
            if (write_en) begin
                // Write data to specified address
                mem[write_addr] <= write_data;
            end
        end
    end
    
    // Read operation pipeline stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_addr_gray <= 3'b0;
            read_data_pipe <= {WIDTH{1'b0}};
            read_valid_pipe <= 1'b0;
        end
        else begin
            read_addr_gray <= bin2gray(read_addr);
            read_valid_pipe <= read_en;
            if (read_en) begin
                // Check for write-through condition
                if (write_en && (write_addr == read_addr)) begin
                    read_data_pipe <= write_data;
                end
                else begin
                    read_data_pipe <= mem[read_addr];
                end
            end
        end
    end
    
    // Read operation pipeline stage 2 (output register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            read_data <= read_valid_pipe ? read_data_pipe : {WIDTH{1'b0}};
        end
    end

endmodule