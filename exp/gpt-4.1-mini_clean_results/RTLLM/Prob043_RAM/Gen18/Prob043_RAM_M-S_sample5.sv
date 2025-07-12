module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                       clk,
    input                       rst_n,
    input                       write_en,
    input       [$clog2(DEPTH)-1:0] write_addr,
    input       [WIDTH-1:0]     write_data,
    input                       read_en,
    input       [$clog2(DEPTH)-1:0] read_addr,
    output reg  [WIDTH-1:0]     read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Write operation: synchronous write
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read operation: synchronous read, cleared on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule