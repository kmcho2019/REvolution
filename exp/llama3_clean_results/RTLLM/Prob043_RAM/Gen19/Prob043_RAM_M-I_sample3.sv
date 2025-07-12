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

reg [5:0] memory [DEPTH-1:0];

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            memory[i] <= 6'b0;
        end
    end else if (write_en) begin
        memory[write_addr] <= write_data;
    end
end

// Read operation
reg [5:0] read_data_temp;
always @(*) begin
    if (read_en) begin
        read_data_temp = memory[read_addr];
    end else begin
        read_data_temp = 6'b0;
    end
end

assign read_data = read_data_temp;

endmodule