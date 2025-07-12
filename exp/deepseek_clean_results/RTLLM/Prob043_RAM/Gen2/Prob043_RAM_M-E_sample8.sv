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
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Pipeline registers
    reg [WIDTH-1:0] read_data_next;
    reg read_valid;

    // Reset logic (only activates when rst_n is low)
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
            read_data_next <= {WIDTH{1'b0}};
            read_valid <= 1'b0;
        end
    end

    // Write operation (synchronous)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
            // Write-through behavior for simultaneous read/write
            if (read_en && (write_addr == read_addr)) begin
                read_data_next <= write_data;
            end
        end
    end

    // Read operation stage 1 (address phase)
    always @(posedge clk) begin
        read_valid <= read_en;
        if (read_en) begin
            read_data_next <= mem[read_addr];
        end
    end

    // Read operation stage 2 (data phase)
    always @(posedge clk) begin
        if (read_valid) begin
            read_data <= read_data_next;
        end
    end

endmodule