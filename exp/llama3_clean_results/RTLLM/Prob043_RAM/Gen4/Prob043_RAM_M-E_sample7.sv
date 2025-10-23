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

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [WIDTH-1:0] read_data_reg;
reg read_granted;

integer i;

// Synchronous write block
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
        read_granted <= 1'b0;
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
        read_granted <= 1'b0;
    end else begin
        read_granted <= 1'b1;
    end
end

// Asynchronous read block with pipelined arbitration
always @(*) begin
    if (read_en && read_granted) begin
        read_data_reg = RAM[read_addr];
    end else begin
        read_data_reg = {WIDTH{1'b0}};
    end
end

assign read_data = read_data_reg;

endmodule