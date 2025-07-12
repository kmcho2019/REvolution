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

// Clock gating for write operation
wire clk_gated;
assign clk_gated = clk & (write_en | ~rst_n);

// Write operation with gated clock
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Parallel reset using concatenation
        {mem[0], mem[1], mem[2], mem[3], 
         mem[4], mem[5], mem[6], mem[7]} <= {DEPTH*WIDTH{1'b0}};
    end
    else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Pipeline register for read operation
reg [5:0] read_data_pipe;

// Read operation with pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_pipe <= {WIDTH{1'b0}};
        read_data <= {WIDTH{1'b0}};
    end
    else begin
        // First stage: address decode
        if (read_en) begin
            read_data_pipe <= mem[read_addr];
        end
        
        // Second stage: output register
        read_data <= read_data_pipe;
    end
end

endmodule