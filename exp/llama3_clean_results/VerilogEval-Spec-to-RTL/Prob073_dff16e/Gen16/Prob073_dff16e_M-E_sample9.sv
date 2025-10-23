module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [7:0] en;

always @(*) begin
    case (byteena)
        2'b00: en = 8'b00000000;
        2'b01: en = 8'b00000011;
        2'b10: en = 8'b11000000;
        2'b11: en = 8'b11000011;
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        q[0]  <= en[0] ? d[0]  : q[0];
        q[1]  <= en[0] ? d[1]  : q[1];
        q[2]  <= en[1] ? d[2]  : q[2];
        q[3]  <= en[1] ? d[3]  : q[3];
        q[4]  <= en[2] ? d[4]  : q[4];
        q[5]  <= en[2] ? d[5]  : q[5];
        q[6]  <= en[3] ? d[6]  : q[6];
        q[7]  <= en[3] ? d[7]  : q[7];
        q[8]  <= en[4] ? d[8]  : q[8];
        q[9]  <= en[4] ? d[9]  : q[9];
        q[10] <= en[5] ? d[10] : q[10];
        q[11] <= en[5] ? d[11] : q[11];
        q[12] <= en[6] ? d[12] : q[12];
        q[13] <= en[6] ? d[13] : q[13];
        q[14] <= en[7] ? d[14] : q[14];
        q[15] <= en[7] ? d[15] : q[15];
    end
end

endmodule