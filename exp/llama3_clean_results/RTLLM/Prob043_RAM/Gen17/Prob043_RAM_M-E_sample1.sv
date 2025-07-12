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

// Dual-bank memory structure
reg [WIDTH-1:0] write_bank [DEPTH-1:0];
reg [WIDTH-1:0] read_bank [DEPTH-1:0];

// Token signals for bank access control
reg write_token;
reg read_token;

// Pipeline stages for write operation
reg [2:0] write_addr_pipe;
reg [5:0] write_data_pipe;

// Pipeline stages for read operation
reg [2:0] read_addr_pipe;
reg [5:0] read_data_pipe;

// Token generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_token <= 1'b0;
        read_token <= 1'b0;
    end else begin
        // Generate token for write operation if bank is available
        if (!write_token && write_en) begin
            write_token <= 1'b1;
        end
        // Generate token for read operation if bank is available
        if (!read_token && read_en) begin
            read_token <= 1'b1;
        end
        // Reset tokens after operation completion
        if (write_token && !write_en) begin
            write_token <= 1'b0;
        end
        if (read_token && !read_en) begin
            read_token <= 1'b0;
        end
    end
end

// Write operation pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_addr_pipe <= 3'b000;
        write_data_pipe <= 6'b000000;
    end else if (write_token) begin
        // Capture write address and data
        write_addr_pipe <= write_addr;
        write_data_pipe <= write_data;
        // Write data to write bank
        write_bank[write_addr_pipe] <= write_data_pipe;
    end
end

// Read operation pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_addr_pipe <= 3'b000;
        read_data_pipe <= 6'b000000;
    end else if (read_token) begin
        // Capture read address
        read_addr_pipe <= read_addr;
        // Read data from read bank
        read_data_pipe <= read_bank[read_addr_pipe];
    end
end

// Data retrieval and writeback
always @(posedge clk) begin
    // Update read data output
    read_data <= read_data_pipe;
    // Update read bank with latest write data
    read_bank[write_addr_pipe] <= write_data_pipe;
end

endmodule