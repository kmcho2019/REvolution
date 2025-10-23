module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                           clk,
    input                           rst_n,
    input                           write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]          write_data,
    input                           read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output     [WIDTH-1:0]          read_data
);

    // RAM array: DEPTH words, each WIDTH bits wide
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset: clear all RAM entries to zero
    // Write operation occurs when write_en is asserted
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Asynchronous read with read enable gating
    // Outputs zero when read_en is deasserted
    assign read_data = read_en ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule