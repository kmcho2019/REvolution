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
    parameter PIPELINED = 1;  // Enable pipelined reads
    
    // Memory array with power-of-two sizing
    reg [WIDTH-1:0] mem [0:7];  // Fixed 8-deep for better synthesis
    
    // Gray-coded address registers
    reg [2:0] write_addr_gray;
    reg [2:0] read_addr_gray;
    
    // Pipeline registers
    reg [WIDTH-1:0] read_data_pipe;
    reg read_valid_pipe;
    
    // Convert binary to gray code
    function [2:0] bin2gray;
        input [2:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Initialize memory (simulation only)
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end
    
    // Convert addresses to gray code
    always @(*) begin
        write_addr_gray = bin2gray(write_addr);
        read_addr_gray = bin2gray(read_addr);
    end
    
    // Write operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset handled in initial block for simulation
        end
        else if (write_en && (write_addr < DEPTH)) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation pipeline stage 1 (combinational)
    wire [WIDTH-1:0] read_data_raw = (read_en && (read_addr < DEPTH)) ? 
                                     mem[read_addr] : {WIDTH{1'b0}};
    
    // Pipeline stage 2 (registered output)
    generate
        if (PIPELINED) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data_pipe <= {WIDTH{1'b0}};
                    read_valid_pipe <= 1'b0;
                end
                else begin
                    read_data_pipe <= read_data_raw;
                    read_valid_pipe <= read_en;
                end
            end
            
            // Output with optional bypass
            always @(*) begin
                read_data = read_valid_pipe ? read_data_pipe : {WIDTH{1'b0}};
            end
        end
        else begin
            // Direct combinational output (low-latency mode)
            always @(*) begin
                read_data = read_data_raw;
            end
        end
    endgenerate

endmodule