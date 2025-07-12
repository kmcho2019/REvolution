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

reg [WIDTH-1:0] mem [0:DEPTH-1];

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize all memory locations to 0
        mem[0] <= 6'b000000;
        mem[1] <= 6'b000000;
        mem[2] <= 6'b000000;
        mem[3] <= 6'b000000;
        mem[4] <= 6'b000000;
        mem[5] <= 6'b000000;
        mem[6] <= 6'b000000;
        mem[7] <= 6'b000000;
    end
    else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b000000;
    end
    else if (read_en) begin
        read_data <= mem[read_addr];
    end
    else begin
        read_data <= 6'b000000;
    end
end

endmodule