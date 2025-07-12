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
    
    // Memory array with registered write path
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] write_data_reg;
    reg [2:0] write_addr_reg;
    reg write_pending;
    
    // Pipelined read path
    reg [5:0] read_data_next;
    reg read_valid;
    
    // Memory initialization and synchronous reset
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            write_data_reg <= {WIDTH{1'b0}};
            write_addr_reg <= 3'b0;
            write_pending <= 1'b0;
        end else begin
            // Registered write path
            if (write_en) begin
                write_data_reg <= write_data;
                write_addr_reg <= write_addr;
                write_pending <= 1'b1;
            end
            
            // Actual memory write (clock-gated)
            if (write_pending) begin
                mem[write_addr_reg] <= write_data_reg;
                write_pending <= 1'b0;
            end
        end
    end
    
    // Pipelined read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
            read_valid <= 1'b0;
        end else begin
            read_valid <= read_en;
            if (read_en)
                read_data_next <= mem[read_addr];
                
            // Output register with valid indicator
            read_data <= read_valid ? read_data_next : {WIDTH{1'b0}};
        end
    end

endmodule