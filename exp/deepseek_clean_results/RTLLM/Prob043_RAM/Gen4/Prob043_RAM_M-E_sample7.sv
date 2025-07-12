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
    
    // Pipeline registers
    reg [2:0] read_addr_reg;
    reg read_en_reg;
    reg [WIDTH-1:0] mem_out_reg;
    
    // Clock gating signals
    wire read_clk_en = read_en | !rst_n;
    wire write_clk_en = write_en | !rst_n;
    
    // Gated clocks
    wire read_clk = clk & read_clk_en;
    wire write_clk = clk & write_clk_en;

    // Memory initialization using system task
    initial begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

    // Write operation (synchronous to write_clk)
    always @(posedge write_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset handled by initial block
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read pipeline stage 1: Address registration
    always @(posedge read_clk or negedge rst_n) begin
        if (!rst_n) begin
            read_addr_reg <= 3'b0;
            read_en_reg <= 1'b0;
        end
        else begin
            read_addr_reg <= read_addr;
            read_en_reg <= read_en;
        end
    end

    // Read pipeline stage 2: Memory access and output registration
    always @(posedge read_clk) begin
        if (read_en_reg) begin
            mem_out_reg <= mem[read_addr_reg];
        end
        else begin
            mem_out_reg <= {WIDTH{1'b0}};
        end
    end

    // Output registration
    always @(posedge read_clk) begin
        read_data <= mem_out_reg;
    end

endmodule