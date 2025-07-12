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

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [WIDTH-1:0] read_data_next;

// Clock-gated write operation
wire write_clk_en = write_en;
wire gated_clk;

// Clock gating cell (synthesis will infer proper clock gating)
assign gated_clk = write_clk_en & clk;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        // No full reset to save area
    end
    else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Pipelined read operation
always @(*) begin
    read_data_next = read_en ? mem[read_addr] : read_data;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= {WIDTH{1'b0}};
    end
    else begin
        read_data <= read_data_next;
    end
end

endmodule