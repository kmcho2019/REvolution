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

reg [WIDTH-1:0] mem [0:DEPTH-1];
integer i; // For initialization loop

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize all memory locations to 0 using loop
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] <= {WIDTH{1'b0}};
        end
    end
    else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Read operation - optimized to maintain value when not enabled
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= {WIDTH{1'b0}};
    end
    else if (read_en) begin
        read_data <= mem[read_addr];
    end
    // Remove else clause to prevent unnecessary transitions
end

endmodule