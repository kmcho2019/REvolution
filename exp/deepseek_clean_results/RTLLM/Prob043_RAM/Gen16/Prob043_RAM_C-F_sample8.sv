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
    parameter REGISTER_OUTPUT = 0;  // Optional output pipelining
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Clean initialization using generate
    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin: INIT
            initial mem[i] = {WIDTH{1'b0}};
        end
    endgenerate
    
    // Synchronous write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Optional: Reset memory if needed
            // for (integer j = 0; j < DEPTH; j = j + 1)
            //     mem[j] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation with optional output register
    generate
        if (REGISTER_OUTPUT) begin
            // Pipelined read for better timing
            always @(posedge clk) begin
                if (read_en)
                    read_data <= mem[read_addr];
                // Else maintain previous value (power optimization)
            end
        end else begin
            // Combinational read for minimum latency
            always @(*) begin
                if (read_en)
                    read_data = mem[read_addr];
                // Else maintain previous value (power optimization)
            end
        end
    endgenerate

endmodule