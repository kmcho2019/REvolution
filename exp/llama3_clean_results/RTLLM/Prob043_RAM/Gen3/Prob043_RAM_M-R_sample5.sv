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

reg [5:0] RAM [7:0];

// Combinatorial logic for read operation
wire [5:0] read_data_comb;
assign read_data_comb = (read_en)? RAM[read_addr] : 6'b0;

// Sequential block for write operation and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Simplified reset logic
        RAM <= '{default: 6'b0};
    end else if (write_en) begin
        // Write operation using case statement
        case (write_addr)
            3'b000: RAM[0] <= write_data;
            3'b001: RAM[1] <= write_data;
            3'b010: RAM[2] <= write_data;
            3'b011: RAM[3] <= write_data;
            3'b100: RAM[4] <= write_data;
            3'b101: RAM[5] <= write_data;
            3'b110: RAM[6] <= write_data;
            3'b111: RAM[7] <= write_data;
        endcase
    end
end

// Directly assign read_data_comb to read_data
assign read_data = read_data_comb;

endmodule