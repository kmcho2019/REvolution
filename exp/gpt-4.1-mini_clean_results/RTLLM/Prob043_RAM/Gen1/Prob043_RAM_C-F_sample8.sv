module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                  clk,
    input                  rst_n,
    input                  write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0] write_data,
    input                  read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    // RAM array: DEPTH locations of WIDTH bits each, initialized to 0 on reset
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Write operation: synchronous, with reset initializing RAM contents to zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Read operation: synchronous, read_data updated when read_en is high; otherwise retains previous value to reduce switching
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end
        // else: retain read_data (do not clear) to avoid unnecessary toggling
    end

endmodule