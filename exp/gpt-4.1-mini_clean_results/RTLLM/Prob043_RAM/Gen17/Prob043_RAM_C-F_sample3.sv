module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH  = 8
)(
    input                             clk,
    input                             rst_n,       // Active low synchronous reset
    input                             write_en,
    input       [$clog2(DEPTH)-1:0]  write_addr,
    input       [WIDTH-1:0]           write_data,
    input                             read_en,
    input       [$clog2(DEPTH)-1:0]  read_addr,
    output      [WIDTH-1:0]           read_data
);

    // RAM array declaration: DEPTH x WIDTH bits
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset and write
    always @(posedge clk) begin
        if (!rst_n) begin
            // Clear all RAM entries to zero on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Write data to RAM at write_addr when write_en is asserted
            RAM[write_addr] <= write_data;
        end
    end

    // Combinational read output with read enable gating to reduce toggling
    assign read_data = read_en ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule