module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array with parameterized dimensions
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    
    // Continuous read with enable gating
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Synchronous write with active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            // Clear all memory locations
            mem[0] <= 0;
            mem[1] <= 0;
            mem[2] <= 0;
            mem[3] <= 0;
            mem[4] <= 0;
            mem[5] <= 0;
            mem[6] <= 0;
            mem[7] <= 0;
        end
        else if (write_en) begin
            // Write to specified address
            mem[write_addr] <= write_data;
        end
    end

endmodule