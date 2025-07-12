module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                             clk,
    input                             rst_n,
    input                             write_en,
    input      [$clog2(DEPTH)-1:0]   write_addr,
    input      [WIDTH-1:0]            write_data,
    input                             read_en,
    input      [$clog2(DEPTH)-1:0]   read_addr,
    output reg [WIDTH-1:0]            read_data
);

    // RAM declaration
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize RAM once at elaboration for FPGA or let synthesis init memory for ASIC
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write process: synchronous write on posedge clk
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read process: synchronous read on posedge clk
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule