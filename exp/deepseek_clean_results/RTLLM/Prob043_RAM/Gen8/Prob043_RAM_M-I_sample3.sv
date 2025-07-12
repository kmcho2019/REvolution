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
    parameter FULL_RESET = 1;  // 1 = reset all memory, 0 = no memory reset
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Memory initialization and write operation
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if (FULL_RESET) begin
                for (i = 0; i < DEPTH; i = i + 1)
                    mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation has priority
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
            
            // Synchronous read operation
            if (read_en) begin
                read_data <= mem[read_addr];
            end
        end
    end

endmodule