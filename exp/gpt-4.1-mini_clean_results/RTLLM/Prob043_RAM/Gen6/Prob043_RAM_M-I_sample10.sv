module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input       [2:0]       write_addr,
    input       [WIDTH-1:0] write_data,
    input                   read_en,
    input       [2:0]       read_addr,
    output reg  [WIDTH-1:0] read_data
);

    // RAM array: depth 8, width 6 bits
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Synchronous reset and write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all RAM locations to zero on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end

            // Read operation: synchronous read
            if (read_en) begin
                read_data <= RAM[read_addr];
            end
            else begin
                // Hold previous read_data value to reduce toggling
                read_data <= read_data;
            end
        end
    end

endmodule