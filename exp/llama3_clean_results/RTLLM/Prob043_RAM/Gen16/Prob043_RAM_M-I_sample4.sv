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

// More compact RAM structure using a single reg array
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Enhanced clock-gating logic considering both write and read operations
reg clk_gated;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else if (write_en || read_en) begin
        // Enable the clock only when necessary
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Unified sequential block for write operation and reset
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Optimized reset logic
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation with optimization for power
assign read_data = (read_en)? RAM[read_addr] : {WIDTH{1'b0}};

endmodule