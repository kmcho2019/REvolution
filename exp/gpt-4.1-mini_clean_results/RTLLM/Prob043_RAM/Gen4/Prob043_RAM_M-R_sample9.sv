module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                       clk,
    input                       rst_n,
    input                       write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]      write_data,
    input                       read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]      read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] read_addr_reg;
    reg read_en_reg;
    integer i;

    // RAM initialization on reset
    always @(negedge rst_n or posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_addr_reg <= 0;
            read_en_reg <= 0;
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation synchronous to clk
            if (write_en)
                RAM[write_addr] <= write_data;

            // Register read address and enable to synchronize reads
            read_addr_reg <= read_addr;
            read_en_reg <= read_en;

            // Registered read output with one cycle latency
            if (read_en_reg)
                read_data <= RAM[read_addr_reg];
            else
                read_data <= {WIDTH{1'b0}};
        end
    end

endmodule