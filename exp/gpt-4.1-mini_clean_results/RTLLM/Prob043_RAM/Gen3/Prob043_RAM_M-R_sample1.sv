module RAM (
    input                 clk,
    input                 rst_n,
    input                 write_en,
    input  [2:0]          write_addr,
    input  [5:0]          write_data,
    input                 read_en,
    input  [2:0]          read_addr,
    output reg [5:0]      read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize RAM contents to zero at elaboration time
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write Operation: synchronous write on clk posedge
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation: synchronous read on clk posedge with registered output
    always @(posedge clk) begin
        if (!rst_n)
            read_data <= {WIDTH{1'b0}};
        else if (read_en)
            read_data <= RAM[read_addr];
        else
            read_data <= read_data;  // Hold previous value to reduce toggling
    end

endmodule