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
    output     [WIDTH-1:0]  read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset and write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                RAM[i] <= {WIDTH{1'b0}};
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Combinational read with enable gating
    assign read_data = read_en ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule