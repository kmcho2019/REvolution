module RAM (
    input             clk,
    input             rst_n,
    input             write_en,
    input      [2:0]   write_addr,
    input      [5:0]   write_data,
    input             read_en,
    input      [2:0]   read_addr,
    output reg [5:0]   read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [WIDTH-1:0] RAM_segment1 [DEPTH/2-1:0];
reg [WIDTH-1:0] RAM_segment2 [DEPTH/2-1:0];

reg [WIDTH-1:0] pipeline_stage1;
reg [WIDTH-1:0] pipeline_stage2;
reg [2:0] addr_stage1;
reg [2:0] addr_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH/2; i++) begin
            RAM_segment1[i] <= {WIDTH{1'b0}};
            RAM_segment2[i] <= {WIDTH{1'b0}};
        end
        pipeline_stage1 <= {WIDTH{1'b0}};
        pipeline_stage2 <= {WIDTH{1'b0}};
        addr_stage1 <= 3'b000;
        addr_stage2 <= 3'b000;
    end else if (write_en) begin
        if (write_addr < DEPTH/2) begin
            RAM_segment1[write_addr] <= write_data;
        end else begin
            RAM_segment2[write_addr - DEPTH/2] <= write_data;
        end
    end
end

always @(posedge clk) begin
    pipeline_stage1 <= (write_en && write_addr < DEPTH/2) ? write_data : {WIDTH{1'b0}};
    addr_stage1 <= (write_en && write_addr < DEPTH/2) ? write_addr : 3'b000;
    pipeline_stage2 <= (read_en && read_addr < DEPTH/2) ? RAM_segment1[read_addr] : (read_en && read_addr >= DEPTH/2) ? RAM_segment2[read_addr - DEPTH/2] : {WIDTH{1'b0}};
    addr_stage2 <= (read_en && read_addr < DEPTH/2) ? read_addr : (read_en && read_addr >= DEPTH/2) ? read_addr - DEPTH/2 : 3'b000;
    read_data <= pipeline_stage2;
end

endmodule