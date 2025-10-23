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

reg [WIDTH-1:0] Bank_W [DEPTH-1:0];
reg [WIDTH-1:0] Bank_R [DEPTH-1:0];
reg [WIDTH-1:0] temp_data;

// Write operation on Bank_W
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            Bank_W[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        Bank_W[write_addr] <= write_data;
        // Synchronize with Bank_R
        Bank_R[write_addr] <= write_data;
    end
end

// Combinatorial read logic from Bank_R
assign read_data = (read_en) ? Bank_R[read_addr] : {WIDTH{1'b0}};

endmodule