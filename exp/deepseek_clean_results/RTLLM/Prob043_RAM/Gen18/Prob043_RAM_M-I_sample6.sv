module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal read data with enable control
    wire [WIDTH-1:0] read_data_int = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Clock gating for read port
    reg read_en_reg;
    always @(posedge clk) begin
        read_en_reg <= read_en;
    end
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Registered read output
    always @(posedge clk) begin
        if (!rst_n)
            read_data <= {WIDTH{1'b0}};
        else
            read_data <= read_data_int;
    end

    /* Design Notes:
    1. Read-during-write behavior: When reading and writing the same address
       simultaneously, this implementation provides the old data (before write).
    2. Clock gating reduces power when read_en is inactive.
    3. Registered output improves timing at the cost of 1-cycle read latency.
    4. Memory initialization is done via initial block for simplicity.
    */

endmodule