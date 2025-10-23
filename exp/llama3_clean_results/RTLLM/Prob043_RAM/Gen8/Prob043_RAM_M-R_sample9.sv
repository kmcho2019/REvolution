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
reg clk_gated;

// Clock gating for power optimization
assign clk_gated = write_en || read_en;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all memory locations
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end
end

// Write operation
always @(posedge clk_gated) begin
    if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Read operation
assign read_data = (read_en) ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule