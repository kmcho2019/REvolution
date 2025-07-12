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
    
    // Internal read data
    wire [WIDTH-1:0] read_data_int;
    assign read_data_int = read_en ? mem[read_addr] : {WIDTH{1'b0}};
    
    // Staggered reset and write operation
    integer reset_counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Staggered reset to reduce peak current
            if (reset_counter < DEPTH) begin
                mem[reset_counter] <= {WIDTH{1'b0}};
                reset_counter <= reset_counter + 1;
            end
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Normal operation
            reset_counter <= 0;
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
            
            // Clock-gated read register
            if (read_en) begin
                read_data <= read_data_int;
            end
        end
    end

endmodule