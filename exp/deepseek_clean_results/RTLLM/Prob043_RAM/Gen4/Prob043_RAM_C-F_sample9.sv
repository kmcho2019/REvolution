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

    // Memory initialization and write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset memory to all zeros
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // Synchronous write operation
            mem[write_addr] <= write_data;
        end
    end

    // Read operation with output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read output
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Only update read_data when read_en is active
            if (read_en) begin
                read_data <= mem[read_addr];
            end
            // Else: maintain previous value (power optimization)
        end
    end

endmodule