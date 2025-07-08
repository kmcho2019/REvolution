module RAM (
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input       [2:0]       write_addr,
    input       [5:0]       write_data,
    input                   read_en,
    input       [2:0]       read_addr,
    output reg  [5:0]       read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM array: DEPTH locations, each WIDTH bits wide
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Write operation and reset initialization
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                RAM[i] <= {WIDTH{1'b0}};
        end else begin
            if (write_en)
                RAM[write_addr] <= write_data;
        end
    end

    // Read operation and reset read_data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else begin
            if (read_en)
                read_data <= RAM[read_addr];
            else
                read_data <= {WIDTH{1'b0}};
        end
    end

endmodule