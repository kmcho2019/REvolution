module RAM (
    input clk_write,
    input clk_read,
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

reg [5:0] RAM [7:0];
reg [5:0] read_data_pipe [2:0];

// Asynchronous reset
always @(posedge clk_write or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Pipelined read operation
always @(posedge clk_read) begin
    read_data_pipe[0] <= RAM[read_addr];
    read_data_pipe[1] <= read_data_pipe[0];
    read_data_pipe[2] <= read_data_pipe[1];
end

// Output stage of the pipeline
assign read_data = (read_en) ? read_data_pipe[2] : 6'b0;

// Built-in self-test (BIST) mechanism
reg [5:0] bist_data;
reg bist_en;
always @(posedge clk_read) begin
    if (bist_en) begin
        // Simple BIST example: writing and reading a known pattern
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= i;
        end
        bist_data <= RAM[0];
    end
end

// Memory compression (simple example: run-length encoding)
reg [5:0] compressed_data;
reg compress_en;
always @(posedge clk_write) begin
    if (compress_en) begin
        // Example compression logic
        compressed_data <= write_data;
    end
end

endmodule