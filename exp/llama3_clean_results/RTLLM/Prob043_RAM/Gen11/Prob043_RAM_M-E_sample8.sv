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

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [2:0] write_addr_pipe;
reg [5:0] write_data_pipe;

// Pipelined write operation
always @(posedge clk) begin
    if (write_en) begin
        write_addr_pipe <= write_addr;
        write_data_pipe <= write_data;
    end
end

always @(posedge clk) begin
    if (write_en) begin
        RAM[write_addr_pipe] <= write_data_pipe;
    end
end

// Parallel read operation
reg [5:0] read_data_pipe;
always @(posedge clk) begin
    if (read_en) begin
        read_data_pipe <= RAM[read_addr];
    end
end

assign read_data = read_data_pipe;

// Asynchronous reset
always @(posedge rst_n or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
        write_addr_pipe <= 3'b000;
        write_data_pipe <= 6'b000000;
        read_data_pipe <= 6'b000000;
    end
end

// Low-power techniques
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else if (write_en || read_en) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

endmodule