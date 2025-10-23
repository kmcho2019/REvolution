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

// Combinatorial logic for read operation
wire [WIDTH-1:0] read_data_comb;
assign read_data_comb = (read_en)? RAM[read_addr] : {WIDTH{1'b0}};

// Simplified sequential block for write operation and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic simplified
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Assign read_data_comb to read_data_reg
always @(posedge clk) begin
    if (read_en) begin
        read_data_reg <= read_data_comb;
    end else begin
        read_data_reg <= {WIDTH{1'b0}};
    end
end

// Clock gating to minimize power consumption
wire clk_gated = (write_en || read_en) ? clk : 1'b0;

// Update the read_data output
assign read_data = read_data_reg;

endmodule