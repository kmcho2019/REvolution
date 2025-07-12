module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [$clog2(DEPTH)-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Synchronous operations (write and read)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset/initialize memory
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation
            if (write_en)
                mem[write_addr] <= write_data;
            
            // Registered read operation
            read_data <= read_en ? mem[read_addr] : {WIDTH{1'b0}};
        end
    end

endmodule