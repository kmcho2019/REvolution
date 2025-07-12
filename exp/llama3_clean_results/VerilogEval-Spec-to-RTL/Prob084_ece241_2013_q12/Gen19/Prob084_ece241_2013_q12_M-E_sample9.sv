module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] reg_data;
reg [2:0] ring_counter;

always @(posedge clk) begin
    if (enable) begin
        ring_counter <= ring_counter + 1;
        reg_data <= {reg_data[6:0], S};
    end
end

always @(*) begin
    case ({A, B, C})
        3'b000: Z <= reg_data[0];
        3'b001: Z <= reg_data[1];
        3'b010: Z <= reg_data[2];
        3'b011: Z <= reg_data[3];
        3'b100: Z <= reg_data[4];
        3'b101: Z <= reg_data[5];
        3'b110: Z <= reg_data[6];
        3'b111: Z <= reg_data[7];
        default: Z <= 1'bx;
    endcase
end

endmodule