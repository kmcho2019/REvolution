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

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    wire clk_gated = clk & (write_en | ~rst_n);

    // Asynchronous reset and memory initialization
    integer i;
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
    end

    // Write operation with clock gating
    always @(posedge clk_gated) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation - only update when enabled
    always @(posedge clk) begin
        if (read_en) begin
            read_data <= mem[read_addr];
        end
    end

endmodule