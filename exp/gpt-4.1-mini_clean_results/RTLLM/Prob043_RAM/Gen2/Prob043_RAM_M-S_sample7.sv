module RAM (
    input                     clk,
    input                     rst_n,
    input                     write_en,
    input      [2:0]          write_addr,
    input      [5:0]          write_data,
    input                     read_en,
    input      [2:0]          read_addr,
    output reg [5:0]          read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each, no synchronous reset to reduce complexity
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize RAM to zero at simulation start (synthesis tools may ignore)
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write Operation: synchronous write only when write_en is asserted
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation: synchronous read with read_data holding value if read_en is low
    always @(posedge clk) begin
        if (read_en) begin
            read_data <= RAM[read_addr];
        end
    end

endmodule