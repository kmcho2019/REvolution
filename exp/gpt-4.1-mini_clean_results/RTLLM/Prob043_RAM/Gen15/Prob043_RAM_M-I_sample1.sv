module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                           clk,
    input                           rst_n,
    input                           write_en,
    input  [$clog2(DEPTH)-1:0]     write_addr,
    input  [WIDTH-1:0]              write_data,
    input                           read_en,
    input  [$clog2(DEPTH)-1:0]     read_addr,
    output [WIDTH-1:0]              read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Initialize RAM content to zeros once at startup
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Synchronous write operation with write enable
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Combinational read with gating by read_en
    assign read_data = read_en ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule