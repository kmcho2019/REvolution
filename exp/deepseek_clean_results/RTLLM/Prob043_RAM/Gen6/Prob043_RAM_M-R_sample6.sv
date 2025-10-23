module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [$clog2(DEPTH)-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration with parameterized dimensions
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Reset logic - clears all memory locations
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
    end
    
    // Write operation - synchronous with clock
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation - synchronous with clock
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            read_data <= mem[read_addr];
        end
    end

endmodule