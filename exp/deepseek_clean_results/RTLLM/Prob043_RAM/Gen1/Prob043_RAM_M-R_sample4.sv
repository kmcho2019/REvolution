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
    
    // Internal signal for read data
    wire [WIDTH-1:0] read_data_raw = mem[read_addr];

    // Reset logic (separate block for better timing)
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
    end

    // Write operation (clock gating could be added here)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation with output hold when not enabled
    always @(posedge clk) begin
        if (read_en) begin
            read_data <= read_data_raw;
        end
        // Else maintain previous value (reduces toggling)
    end

    // Alternative implementation using continuous assignment:
    // assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    // Note: This would make read_data change immediately when read_addr changes,
    // not on clock edge, which may not be desired for synchronous operation

endmodule