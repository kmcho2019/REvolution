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
    
    // Validate parameters
    initial begin
        if (WIDTH <= 0) $error("WIDTH must be positive");
        if (DEPTH <= 0) $error("DEPTH must be positive");
        if (DEPTH > 2**$clog2(DEPTH)) 
            $warning("DEPTH is not power of 2, memory will be partially unused");
    end

    // Memory array - packed for better area efficiency
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation - synchronous with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all memory locations (blocking for immediate effect)
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] = {WIDTH{1'b0}};
        end
        else if (write_en) begin
            // Synchronous write with clock enable
            mem[write_addr] <= write_data;
        end
    end

    // Combinational read path with output enable
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};

endmodule