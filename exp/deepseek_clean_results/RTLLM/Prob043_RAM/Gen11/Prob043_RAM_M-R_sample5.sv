module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory as packed array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Synchronous write operation with clock enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Write to specified address
            mem[write_addr] <= write_data;
        end
    end

    // Combinational read path
    wire [WIDTH-1:0] raw_read_data = mem[read_addr];
    
    // Output with enable control
    assign read_data = read_en ? raw_read_data : {WIDTH{1'b0}};

endmodule