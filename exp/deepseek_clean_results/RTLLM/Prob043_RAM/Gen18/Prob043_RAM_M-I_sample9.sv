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
    
    // Memory as packed array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] read_data_reg;

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation - registered output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data_reg <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data_reg <= mem[read_addr];
        end else begin
            read_data_reg <= {WIDTH{1'b0}};
        end
    end

    // Output assignment
    always @(*) begin
        read_data = read_data_reg;
    end

endmodule