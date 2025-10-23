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

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Task to reset RAM contents to zero
    task reset_ram;
        integer idx;
        begin
            for (idx = 0; idx < DEPTH; idx = idx + 1) begin
                RAM[idx] = {WIDTH{1'b0}};
            end
        end
    endtask

    // Synchronous write and reset RAM contents on negedge rst_n
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_ram();
            read_data <= {WIDTH{1'b0}};
        end else begin
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
            if (read_en) begin
                read_data <= RAM[read_addr];
            end else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule