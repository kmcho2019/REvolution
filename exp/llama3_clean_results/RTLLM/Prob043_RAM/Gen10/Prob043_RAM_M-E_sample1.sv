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

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end
end

// Write operation
always @(posedge clk) begin
    if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Read operation using multiplexer
always @(posedge clk) begin
    if (read_en) begin
        case (read_addr)
            3'b000: read_data <= RAM[0];
            3'b001: read_data <= RAM[1];
            3'b010: read_data <= RAM[2];
            3'b011: read_data <= RAM[3];
            3'b100: read_data <= RAM[4];
            3'b101: read_data <= RAM[5];
            3'b110: read_data <= RAM[6];
            3'b111: read_data <= RAM[7];
            default: read_data <= 6'b0;
        endcase
    end else begin
        read_data <= 6'b0;
    end
end

endmodule