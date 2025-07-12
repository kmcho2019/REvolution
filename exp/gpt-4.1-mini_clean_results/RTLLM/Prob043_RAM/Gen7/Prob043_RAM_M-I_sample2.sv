module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                         clk,
    input                         rst_n,
    input                         write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]        write_data,
    input                         read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]        read_data
);

    // RAM memory array
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Initialize memory synchronously on reset (optional: can be removed for less reset latency)
    always @(posedge clk) begin
        if (!rst_n) begin
            // Do not clear entire RAM to save reset latency and power
            // Optionally can initialize RAM here if required by design
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end

            // Read operation synchronous with output register
            if (read_en) begin
                read_data <= RAM[read_addr];
            end
            // else hold previous read_data to reduce toggling/power
        end
    end

endmodule