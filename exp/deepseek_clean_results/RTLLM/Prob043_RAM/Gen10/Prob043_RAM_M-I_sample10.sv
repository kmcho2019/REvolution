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
    parameter REGISTER_OUTPUT = 1;  // 1 for registered output, 0 for combinational
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal signals
    wire [WIDTH-1:0] read_data_raw;
    
    // Memory initialization (synthesis-friendly)
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Combinational read path
    assign read_data_raw = mem[read_addr];
    
    // Output register when enabled
    generate
        if (REGISTER_OUTPUT) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    read_data <= {WIDTH{1'b0}};
                end
                else if (read_en) begin
                    read_data <= read_data_raw;
                end
                // Else maintain previous value (reduces switching power)
            end
        end
        else begin
            always @(*) begin
                read_data = read_en ? read_data_raw : {WIDTH{1'b0}};
            end
        end
    endgenerate

endmodule