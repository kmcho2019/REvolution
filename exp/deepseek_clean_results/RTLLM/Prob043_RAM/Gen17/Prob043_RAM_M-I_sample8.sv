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
    
    // Memory as packed array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 0;
        end else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation with registered output
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= 0;
        end else if (read_en) begin
            read_data <= mem[read_addr];
        end
    end

endmodule