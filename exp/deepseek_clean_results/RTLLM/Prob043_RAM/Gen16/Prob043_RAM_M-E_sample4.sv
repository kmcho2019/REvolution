module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data,
    output reg data_valid
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    
    // Initialization control
    reg [2:0] init_counter;
    wire [2:0] init_counter_gray;
    reg init_done;
    
    // Gray code conversion for initialization counter
    assign init_counter_gray = init_counter ^ (init_counter >> 1);
    
    // Staggered memory initialization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            init_counter <= 0;
            init_done <= 0;
        end else if (!init_done) begin
            mem[init_counter_gray] <= 0;
            init_counter <= init_counter + 1;
            if (&init_counter) init_done <= 1;
        end
    end
    
    // Write operation
    always @(posedge clk) begin
        if (init_done && write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Pipelined read operation
    reg [5:0] read_data_next;
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= 0;
            data_valid <= 0;
        end else begin
            data_valid <= read_en;
            if (read_en) begin
                read_data <= mem[read_addr];
            end else begin
                read_data <= 0;
            end
        end
    end

endmodule