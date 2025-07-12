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

    // Memory array with generate-based initialization
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    genvar i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : mem_init
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) mem[i] <= {WIDTH{1'b0}};
            end
        end
    endgenerate

    // Registered write path
    reg [2:0] wr_addr_reg;
    reg [5:0] wr_data_reg;
    reg wr_en_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_addr_reg <= 3'b0;
            wr_data_reg <= {WIDTH{1'b0}};
            wr_en_reg <= 1'b0;
        end else begin
            wr_addr_reg <= write_addr;
            wr_data_reg <= write_data;
            wr_en_reg <= write_en;
        end
    end

    // Write operation with registered inputs
    always @(posedge clk) begin
        if (wr_en_reg) begin
            mem[wr_addr_reg] <= wr_data_reg;
        end
    end

    // Pipelined read operation
    reg [2:0] rd_addr_reg;
    reg rd_en_reg;
    reg [WIDTH-1:0] mem_out;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_addr_reg <= 3'b0;
            rd_en_reg <= 1'b0;
            mem_out <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end else begin
            rd_addr_reg <= read_addr;
            rd_en_reg <= read_en;
            
            // Memory read with bypass for write-to-read same address
            if (wr_en_reg && (wr_addr_reg == read_addr)) begin
                mem_out <= wr_data_reg;
            end else if (read_en) begin
                mem_out <= mem[read_addr];
            end
            
            // Output register maintains value when not reading
            if (rd_en_reg) begin
                read_data <= mem_out;
            end
        end
    end

endmodule