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
    reg [2:0] read_addr_reg;
    reg read_en_reg;

    // Memory initialization and reset
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

    // Write operation (without reset)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation pipeline stage 1 (address register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_addr_reg <= 3'b0;
            read_en_reg <= 1'b0;
        end else begin
            read_addr_reg <= read_addr;
            read_en_reg <= read_en;
        end
    end

    // Read operation pipeline stage 2 (data output)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en_reg) begin
            read_data <= mem[read_addr_reg];
        end
        // Maintain previous value when not reading
    end

endmodule