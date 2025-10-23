module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH  = 8
)(
    input                        clk,
    input                        rst_n,       // Active low reset
    input                        write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]       write_data,
    input                        read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]       read_data
);

    // RAM array: DEPTH entries of WIDTH bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Synchronous write and read operations
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else begin
            if (write_en)
                RAM[write_addr] <= write_data;
            if (read_en)
                read_data <= RAM[read_addr];
            else
                read_data <= {WIDTH{1'b0}};
        end
    end

endmodule