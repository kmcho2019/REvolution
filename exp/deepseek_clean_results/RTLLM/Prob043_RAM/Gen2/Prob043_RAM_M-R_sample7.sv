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
localparam ADDR_WIDTH = $clog2(DEPTH);

// Memory array declaration
reg [WIDTH-1:0] mem [0:DEPTH-1];

// Reset and initialization
always @(negedge rst_n) begin
    if (!rst_n) begin
        // Initialize all memory locations to 0
        for (int i = 0; i < DEPTH; i = i + 1) begin
            mem[i] <= {WIDTH{1'b0}};
        end
        read_data <= {WIDTH{1'b0}};
    end
end

// Write operation (synchronous)
always @(posedge clk) begin
    if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Read operation (synchronous with output hold)
always @(posedge clk) begin
    if (read_en) begin
        read_data <= mem[read_addr];
    end
end

endmodule