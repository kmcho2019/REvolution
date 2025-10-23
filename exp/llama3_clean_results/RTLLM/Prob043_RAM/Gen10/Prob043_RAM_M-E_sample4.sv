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
reg [2:0] addr_map [DEPTH-1:0];

// Initialize address mapping during reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            addr_map[i] <= i;
        end
    end
end

// Pipeline stage 1: address mapping
reg [2:0] mapped_addr;
always @(posedge clk) begin
    if (write_en) begin
        mapped_addr <= addr_map[write_addr];
    end
end

// Pipeline stage 2: data retrieval
reg [5:0] read_data_reg;
always @(posedge clk) begin
    if (read_en) begin
        read_data_reg <= RAM[read_addr];
    end
end

// Pipeline stage 3: data storage
always @(posedge clk) begin
    if (write_en) begin
        RAM[mapped_addr] <= write_data;
    end
end

// Output read data
assign read_data = (read_en) ? read_data_reg : {WIDTH{1'b0}};

endmodule