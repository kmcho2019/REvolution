module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                          clk,
    input                          rst_n,
    input                          write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]          write_data,
    input                          read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]          read_data
);

    // Memory declaration
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Asynchronous reset with parallel initialization for all RAM locations
    genvar idx;
    generate
        for (idx = 0; idx < DEPTH; idx = idx + 1) begin : mem_reset_block
            always @(negedge rst_n or posedge clk) begin
                if (!rst_n)
                    RAM[idx] <= {WIDTH{1'b0}};
                else if (write_en && (write_addr == idx))
                    RAM[idx] <= write_data;
            end
        end
    endgenerate

    // Registered read_data updated synchronously when read_en is asserted
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