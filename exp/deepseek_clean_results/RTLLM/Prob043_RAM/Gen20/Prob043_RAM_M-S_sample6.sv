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

    // Memory array
    reg [5:0] mem [0:7];
    
    // Synchronous operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset memory and output
            for (int i = 0; i < 8; i++)
                mem[i] <= 6'b0;
            read_data <= 6'b0;
        end
        else begin
            // Write operation
            if (write_en)
                mem[write_addr] <= write_data;
            
            // Read operation
            if (read_en)
                read_data <= mem[read_addr];
        end
    end

endmodule