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

    // Memory array declaration (6-bit width x 8 depth)
    reg [5:0] mem [0:7];

    // Write operation with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all memory locations to 0
            for (integer i = 0; i < 8; i = i + 1)
                mem[i] <= 6'b0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (read_en)
            read_data = mem[read_addr];
    end

endmodule