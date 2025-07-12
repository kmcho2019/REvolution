module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,  // Explicit 3-bit for DEPTH=8
    input [5:0] write_data,  // Explicit 6-bit for WIDTH=6
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    // Memory array declaration
    reg [5:0] mem [0:7];  // DEPTH=8, WIDTH=6
    
    // Internal signals
    reg [5:0] read_data_next;
    wire read_during_write = (write_en && read_en && (write_addr == read_addr));
    
    // Combinational read with enable and write-through bypass
    always @(*) begin
        if (read_en) begin
            if (read_during_write)
                read_data_next = write_data;  // Bypass for write-through
            else
                read_data_next = mem[read_addr];
        end else begin
            read_data_next = read_data;  // Maintain previous value
        end
    end
    
    // Synchronous operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b0;
        end else begin
            // Registered read output
            read_data <= read_data_next;
            
            // Synchronous write
            if (write_en)
                mem[write_addr] <= write_data;
        end
    end

endmodule