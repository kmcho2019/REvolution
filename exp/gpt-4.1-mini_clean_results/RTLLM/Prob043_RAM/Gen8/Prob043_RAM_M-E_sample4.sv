module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]  write_data,
    input                   read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]  read_data
);

    // Declare the RAM memory array
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize RAM to zero at simulation start (for simulation convenience)
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write operation: synchronous, writes on posedge clk if write_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear entire RAM to zero
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read operation: synchronous, output register updated on posedge clk or cleared on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end
        // else retain previous read_data value (hold)
    end

endmodule