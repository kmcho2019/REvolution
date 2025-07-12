module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                       clk,
    input                       rst_n,
    input                       write_en,
    input  [$clog2(DEPTH)-1:0] write_addr,
    input  [WIDTH-1:0]          write_data,
    input                       read_en,
    input  [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]      read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset and write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
            // Registered read operation with hold on read_data if read_en is low
            if (read_en) begin
                read_data <= RAM[read_addr];
            end
            // else retain previous read_data value to minimize toggling
        end
    end

endmodule