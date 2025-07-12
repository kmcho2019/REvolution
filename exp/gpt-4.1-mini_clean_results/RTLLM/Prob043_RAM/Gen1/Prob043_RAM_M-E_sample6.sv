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
    
    // Initialize RAM asynchronously using initial block
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Write on clock edge
    always @(posedge clk) begin
        if (!rst_n) begin
            // Asynchronous reset disables writes; rely on initial block for init
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Combinational read logic with read enable gating
    always @(*) begin
        if (!rst_n) begin
            read_data = {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data = RAM[read_addr];
        end else begin
            read_data = {WIDTH{1'b0}};
        end
    end

endmodule