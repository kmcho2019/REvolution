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

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    reg resetting;

    // Reset logic: initialize RAM contents using a separate state signal 'resetting' to spread initialization over multiple cycles if needed.
    // Here we perform reset at once, inside the always block.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en)
                RAM[write_addr] <= write_data;
            // Synchronous read data output
            if (read_en)
                read_data <= RAM[read_addr];
            else
                read_data <= {WIDTH{1'b0}};
        end
    end

endmodule