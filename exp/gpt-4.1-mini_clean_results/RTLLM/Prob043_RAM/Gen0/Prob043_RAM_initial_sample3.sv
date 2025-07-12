module RAM (
    input wire clk,
    input wire rst_n,
    input wire write_en,
    input wire [2:0] write_addr,
    input wire [5:0] write_data,
    input wire read_en,
    input wire [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Define RAM array: 2^WIDTH locations of WIDTH bits each
    reg [WIDTH-1:0] RAM [0:(2**WIDTH)-1];

    integer i;

    // Write operation and reset logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all memory locations to 0 on reset
            for (i = 0; i < (2**WIDTH); i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else begin
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
        end
    end

    // Read operation and reset logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else begin
            if (read_en) begin
                read_data <= RAM[read_addr];
            end else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule