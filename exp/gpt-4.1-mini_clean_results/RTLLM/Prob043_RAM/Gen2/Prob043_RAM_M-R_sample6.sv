module RAM (
    input                     clk,
    input                     rst_n,
    input                     write_en,
    input  [2:0]              write_addr,
    input  [5:0]              write_data,
    input                     read_en,
    input  [2:0]              read_addr,
    output     [5:0]          read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM Array: 8 words of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    
    integer i;

    // Synchronous reset of RAM contents
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end
    end

    // Write operation: synchronous write to RAM
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Combinational read: output RAM content at read_addr if read_en is high, else zeros
    assign read_data = (read_en) ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule