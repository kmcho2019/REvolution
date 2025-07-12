module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
) (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [WIDTH-1:0] read_data
);

reg [WIDTH-1:0] RAM_write [DEPTH-1:0];
reg [WIDTH-1:0] RAM_read [DEPTH-1:0];
reg [WIDTH-1:0] read_data_reg;

integer i;

// Synchronous write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < DEPTH; i++) begin
            RAM_write[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        RAM_write[write_addr] <= write_data;
    end
end

// Asynchronous read operation with arbitration
always @(*) begin
    if (read_en) begin
        if (read_addr == write_addr && write_en) begin
            // Arbitrate access to the RAM array
            read_data_reg = {WIDTH{1'b0}};
        end else begin
            read_data_reg = RAM_read[read_addr];
        end
    end else begin
        read_data_reg = {WIDTH{1'b0}};
    end
end

// Update the read RAM array asynchronously
always @(*) begin
    for (i = 0; i < DEPTH; i++) begin
        RAM_read[i] = RAM_write[i];
    end
end

assign read_data = read_data_reg;

endmodule