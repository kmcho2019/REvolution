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
    
    // Memory array declaration and initialization
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Internal combinational read
    wire [WIDTH-1:0] read_data_int = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Synchronous write operation (reset handled by initial block)
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
            
        // Registered read output for better timing
        read_data <= read_data_int;
    end

    /* Clock gating suggestion for power optimization:
    // wire gated_clk = clk & (write_en | read_en);
    // always @(posedge gated_clk) begin ... 
    // Would require careful timing analysis */
    
    /* Read-during-write behavior:
    When reading and writing the same address simultaneously:
    - The read will return the OLD value (before write)
    - New value will be available on next clock cycle */
endmodule