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
    parameter PIPELINE_OUTPUT = 1;  // Enable output register
    
    // Gray code conversion functions
    function [2:0] bin2gray;
        input [2:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Memory banks (A and B)
    reg [WIDTH-1:0] mem_bank_A [0:DEPTH-1];
    reg [WIDTH-1:0] mem_bank_B [0:DEPTH-1];
    
    // Bank selection and control signals
    reg bank_sel;
    reg [2:0] write_addr_gray, read_addr_gray;
    wire [2:0] write_addr_bin, read_addr_bin;
    
    // Pipeline registers
    reg [WIDTH-1:0] write_data_reg;
    reg write_en_reg;
    reg [2:0] write_addr_reg;
    
    // Internal signals
    wire [WIDTH-1:0] read_data_raw;
    reg [WIDTH-1:0] read_data_int;
    
    // Gray to binary conversion
    assign write_addr_bin = write_addr_gray ^ (write_addr_gray >> 1);
    assign read_addr_bin = read_addr_gray ^ (read_addr_gray >> 1);
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem_bank_A[i] = {WIDTH{1'b0}};
            mem_bank_B[i] = {WIDTH{1'b0}};
        end
        bank_sel = 0;
    end
    
    // Address gray coding
    always @(posedge clk) begin
        write_addr_gray <= bin2gray(write_addr);
        read_addr_gray <= bin2gray(read_addr);
    end
    
    // Pipeline stage for write path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_data_reg <= 0;
            write_en_reg <= 0;
            write_addr_reg <= 0;
        end else begin
            write_data_reg <= write_data;
            write_en_reg <= write_en;
            write_addr_reg <= write_addr_bin;
        end
    end
    
    // Bank switching and write operation
    always @(posedge clk) begin
        bank_sel <= ~bank_sel;
        
        if (write_en_reg) begin
            if (bank_sel) begin
                mem_bank_A[write_addr_reg] <= write_data_reg;
            end else begin
                mem_bank_B[write_addr_reg] <= write_data_reg;
            end
        end
    end
    
    // Read operation with write-through
    assign read_data_raw = (bank_sel ? mem_bank_B : mem_bank_A)[read_addr_bin];
    
    always @(*) begin
        if (write_en && read_en && (write_addr == read_addr)) begin
            read_data_int = write_data;  // Write-through
        end else if (read_en) begin
            read_data_int = read_data_raw;
        end else begin
            read_data_int = {WIDTH{1'b0}};
        end
    end
    
    // Optional output pipeline register
    generate
        if (PIPELINE_OUTPUT) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data <= 0;
                end else begin
                    read_data <= read_data_int;
                end
            end
        end else begin
            always @(*) begin
                read_data = read_data_int;
            end
        end
    endgenerate

endmodule