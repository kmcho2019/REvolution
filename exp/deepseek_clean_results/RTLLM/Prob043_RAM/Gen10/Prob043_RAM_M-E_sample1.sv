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
    
    // Main memory and shadow registers
    reg [WIDTH-1:0] main_mem [0:DEPTH-1];
    reg [WIDTH-1:0] shadow_mem [0:DEPTH-1];
    
    // Write address register for conflict detection
    reg [2:0] write_addr_reg;
    reg write_pending;
    
    // Initialize memory
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                main_mem[i] <= {WIDTH{1'b0}};
                shadow_mem[i] <= {WIDTH{1'b0}};
            end
            write_addr_reg <= 3'b0;
            write_pending <= 1'b0;
        end else begin
            // Main memory update
            if (write_en) begin
                main_mem[write_addr] <= write_data;
                write_addr_reg <= write_addr;
                write_pending <= 1'b1;
            end else begin
                write_pending <= 1'b0;
            end
            
            // Shadow memory update (only when written location)
            if (write_pending) begin
                shadow_mem[write_addr_reg] <= main_mem[write_addr_reg];
            end
        end
    end
    
    // Read path with output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            // Read from shadow memory
            read_data <= shadow_mem[read_addr];
            
            // Special case: read-during-write to same address
            if (write_pending && (read_addr == write_addr_reg)) begin
                read_data <= main_mem[write_addr_reg];
            end
        end
    end

endmodule