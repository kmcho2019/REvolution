module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input [2:0] read_addr,
    output [5:0] read_data
);

    reg [5:0] mem [0:7];
    
    // Synchronous write with reset initialization
    always @(posedge clk) begin
        if (!rst_n) begin
            mem[0] <= 6'b0;
            mem[1] <= 6'b0;
            mem[2] <= 6'b0;
            mem[3] <= 6'b0;
            mem[4] <= 6'b0;
            mem[5] <= 6'b0;
            mem[6] <= 6'b0;
            mem[7] <= 6'b0;
        end
        else if (write_en)
            mem[write_addr] <= write_data;
    end

    // Continuous read (always enabled)
    assign read_data = mem[read_addr];

endmodule