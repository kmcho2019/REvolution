module RAM (
    input                 clk,
    input                 rst_n,
    input                 write_en,
    input  [2:0]          write_addr,
    input  [5:0]          write_data,
    input                 read_en,
    input  [2:0]          read_addr,
    output reg [5:0]      read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Synchronous write and reset-clear RAM contents
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Registered read address for synchronous read
    reg [2:0] read_addr_reg;
    reg read_en_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_addr_reg <= 3'b0;
            read_en_reg <= 1'b0;
            read_data <= {WIDTH{1'b0}};
        end else begin
            read_addr_reg <= read_addr;
            read_en_reg <= read_en;
            if (read_en_reg)
                read_data <= RAM[read_addr_reg];
            else
                read_data <= read_data; // Hold previous data, no zeroing to reduce toggling
        end
    end

endmodule