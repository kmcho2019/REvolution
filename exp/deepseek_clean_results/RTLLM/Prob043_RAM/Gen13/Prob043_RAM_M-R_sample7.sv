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
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation and memory reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Output reset register
    reg [WIDTH-1:0] read_data_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            read_data_reg <= {WIDTH{1'b0}};
    end

    // Read operation with continuous assign
    assign read_data = read_en ? mem[read_addr] : read_data_reg;

endmodule