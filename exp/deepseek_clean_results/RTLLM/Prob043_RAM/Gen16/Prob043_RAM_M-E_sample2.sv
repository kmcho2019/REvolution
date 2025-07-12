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
    parameter ADDR_WIDTH = 3;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write-through and bypass logic
    wire [WIDTH-1:0] read_raw = mem[read_addr];
    wire [WIDTH-1:0] bypass_data = (write_en && (write_addr == read_addr)) ? 
                                   write_data : read_raw;
    
    // Synchronous reset and initialization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize memory
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
            
            // Pipelined read operation
            read_data <= read_en ? bypass_data : {WIDTH{1'b0}};
        end
    end
    
    // Error detection (optional)
    always @(posedge clk) begin
        if (write_en && (write_addr >= DEPTH))
            $display("Warning: Write address out of range");
        if (read_en && (read_addr >= DEPTH))
            $display("Warning: Read address out of range");
    end

endmodule