module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                           clk,
    input                           rst_n,
    input                           write_en,
    input       [$clog2(DEPTH)-1:0] write_addr,
    input       [WIDTH-1:0]         write_data,
    input                           read_en,
    input       [$clog2(DEPTH)-1:0] read_addr,
    output reg  [WIDTH-1:0]         read_data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Optional initial block for simulation (synthesis tools might ignore)
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Synchronous write operation; no RAM-wide reset to optimize timing and power
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Synchronous read with read enable gating and reset for output register only
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