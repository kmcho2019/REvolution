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
    reg [2:0] init_counter;
    
    // Write operation with staggered reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            init_counter <= 0;
            mem[init_counter] <= {WIDTH{1'b0}};
            if (init_counter < DEPTH-1)
                init_counter <= init_counter + 1;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Registered read operation
    always @(posedge clk) begin
        if (read_en)
            read_data <= mem[read_addr];
    end

endmodule