module RAM (
    input                     clk,
    input                     rst_n,
    input                     write_en,
    input      [2:0]          write_addr,
    input      [5:0]          write_data,
    input                     read_en,
    input      [2:0]          read_addr,
    output reg [5:0]          read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Synchronous reset and write process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all RAM locations to zero on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
            // Read operation: register output
            if (read_en) begin
                read_data <= RAM[read_addr];
            end else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule