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
    
    // Memory as packed array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    wire gated_clk = clk & write_en;

    // Write operation with clock gating
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end else begin
            mem[write_addr] <= write_data;
        end
    end

    // Registered read path
    wire [WIDTH-1:0] raw_read_data = mem[read_addr];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= raw_read_data;
        end
        // Else maintain previous value to reduce switching
    end

endmodule