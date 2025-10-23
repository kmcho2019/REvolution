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

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal read data register
    reg [WIDTH-1:0] read_data_reg;

    // Reset and initialization
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
    end

    // Write operation (clock gating could be added here)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation
    always @(posedge clk) begin
        if (read_en) begin
            read_data_reg <= mem[read_addr];
        end
    end

    // Output muxing
    assign read_data = read_en ? read_data_reg : {WIDTH{1'b0}};

    /* Clock gating suggestion for power optimization:
    wire gated_clk;
    assign gated_clk = clk & (write_en | read_en);
    // Then use gated_clk in the always blocks instead of clk
    */

endmodule