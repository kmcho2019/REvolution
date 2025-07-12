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
    
    // Main memory registers and shadow registers
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] shadow_mem [0:DEPTH-1];
    
    // Write pipeline register
    reg [2:0] write_addr_delayed;
    reg [5:0] write_data_delayed;
    reg write_pending;
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= 0;
                shadow_mem[i] <= 0;
            end
            write_pending <= 0;
        end else begin
            // Stage 1: Capture write request
            if (write_en) begin
                mem[write_addr] <= write_data;
                write_addr_delayed <= write_addr;
                write_data_delayed <= write_data;
                write_pending <= 1;
            end else begin
                write_pending <= 0;
            end
            
            // Stage 2: Update shadow memory
            if (write_pending) begin
                shadow_mem[write_addr_delayed] <= write_data_delayed;
            end
        end
    end
    
    // Read operation - always combinatorial from shadow memory
    always @(*) begin
        if (read_en) begin
            read_data = shadow_mem[read_addr];
        end else begin
            read_data = 0;
        end
    end

endmodule