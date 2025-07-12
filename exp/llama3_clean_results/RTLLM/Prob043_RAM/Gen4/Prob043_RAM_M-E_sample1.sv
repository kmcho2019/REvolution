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

reg [5:0] bank1 [7:0];
reg [5:0] bank2 [7:0];

reg [2:0] current_bank;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            bank1[i] <= 6'b0;
            bank2[i] <= 6'b0;
        end
        current_bank <= 3'b000;
    end else if (write_en) begin
        if (current_bank == 3'b000) begin
            bank1[write_addr] <= write_data;
            current_bank <= 3'b001;
        end else begin
            bank2[write_addr] <= write_data;
            current_bank <= 3'b000;
        end
    end
end

wire [5:0] read_data_comb;
assign read_data_comb = (read_en)? (current_bank == 3'b000)? bank1[read_addr] : bank2[read_addr] : 6'b0;

assign read_data = read_data_comb;

endmodule