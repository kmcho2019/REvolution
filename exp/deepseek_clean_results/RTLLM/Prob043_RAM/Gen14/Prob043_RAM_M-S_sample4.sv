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
    
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    integer i;
    
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

endmodule