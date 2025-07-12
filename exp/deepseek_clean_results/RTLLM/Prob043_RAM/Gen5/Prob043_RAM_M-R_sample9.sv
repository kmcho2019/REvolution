module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [$clog2(DEPTH)-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Reset logic
    integer i;
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
    end
    
    // Write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Read operation - combinational
    wire [WIDTH-1:0] read_data_raw = mem[read_addr];
    
    always @(*) begin
        read_data = read_en ? read_data_raw : read_data;
    end

endmodule