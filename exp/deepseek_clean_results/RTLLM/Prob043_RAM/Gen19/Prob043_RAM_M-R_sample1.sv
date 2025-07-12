module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [$clog2(DEPTH)-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [$clog2(DEPTH)-1:0] read_addr,
    output logic [WIDTH-1:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Memory array declaration
    logic [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Synchronous reset and write operation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (int i = 0; i < DEPTH; i++)
                mem[i] <= '0;
        end
        else if (write_en) begin
            // Normal write operation
            mem[write_addr] <= write_data;
        end
    end
    
    // Combinational read with enable
    always_comb begin
        if (read_en)
            read_data = mem[read_addr];
        else
            read_data = '0;
        // Note: When reading and writing to same address simultaneously,
        // this implementation returns the old data (no write-through)
    end

endmodule