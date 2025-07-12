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

reg [5:0] ram_array [7:0];
reg [5:0] read_data_reg;

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            ram_array[i] <= 6'b0;
        end
    end else if (write_en) begin
        ram_array[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_reg <= 6'b0;
    end else if (read_en) begin
        read_data_reg <= ram_array[read_addr];
    end
end

assign read_data = read_data_reg;

endmodule