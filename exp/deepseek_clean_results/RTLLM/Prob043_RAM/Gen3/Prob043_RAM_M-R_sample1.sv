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
parameter INIT_VAL = 6'b000000;

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [WIDTH-1:0] read_data_reg;

// Memory initialization and write operation
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] <= INIT_VAL;
        end
    end
    else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Read operation - combinational when enabled
assign read_data = read_en ? mem[read_addr] : read_data_reg;

// Register to hold read_data when not actively reading
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_reg <= INIT_VAL;
    end
    else if (read_en) begin
        read_data_reg <= mem[read_addr];
    end
end

endmodule