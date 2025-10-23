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

// Dual RAM blocks for writing and reading
reg [5:0] write_ram [7:0];
reg [5:0] read_ram [7:0];

// Distributed reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset write RAM
        for (int i = 0; i < DEPTH; i++) begin
            write_ram[i] <= 6'b0;
        end
        // Reset read RAM
        for (int i = 0; i < DEPTH; i++) begin
            read_ram[i] <= 6'b0;
        end
    end
end

// Write operation
always @(posedge clk) begin
    if (write_en) begin
        write_ram[write_addr] <= write_data;
        // Synchronize data with read RAM
        read_ram[write_addr] <= write_data;
    end
end

// Read operation
assign read_data = (read_en) ? read_ram[read_addr] : 6'b0;

// Dynamic clock gating for power optimization
wire clk_gated;
reg [1:0] activity_counter;

always @(posedge clk) begin
    if (write_en || read_en) begin
        activity_counter <= activity_counter + 1;
    end else begin
        activity_counter <= activity_counter - 1;
    end
end

assign clk_gated = (activity_counter > 0) ? clk : 1'b0;

endmodule