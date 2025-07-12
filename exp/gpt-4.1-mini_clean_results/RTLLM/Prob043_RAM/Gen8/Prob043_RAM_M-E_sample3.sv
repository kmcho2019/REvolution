module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                    clk,
    input                    rst_n,
    input                    write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]   write_data,
    input                    read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]   read_data
);

    // Memory array: DEPTH entries, each WIDTH bits wide
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Asynchronous reset logic to clear RAM contents
    // Synthesis tools typically infer synchronous reset; for true async reset,
    // an asynchronous reset enable signal or a separate reset process would be used.
    // Here, implement a synchronous reset for synthesis, plus an initial block for simulation.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Asynchronous combinational read port: reads RAM immediately upon change of read_addr or read_en
    always @(*) begin
        if (read_en)
            read_data = RAM[read_addr];
        else
            read_data = {WIDTH{1'b0}};
    end

    // For simulation only: Initialize RAM to zero at time zero to avoid X's.
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

endmodule