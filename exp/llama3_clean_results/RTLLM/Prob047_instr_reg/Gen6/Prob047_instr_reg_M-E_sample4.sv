module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

// Instruction Buffer (IBUF)
reg [7:0] ibuf;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ibuf <= 8'd0;
    end else if (fetch == 2'b01 || fetch == 2'b10) begin
        ibuf <= data;
    end
end

// Instruction Decoder (IDEC)
wire [2:0] idec_ins;
wire [4:0] idec_ad1;
wire [7:0] idec_ad2;
assign idec_ins = ibuf[7:5];
assign idec_ad1 = ibuf[4:0];
assign idec_ad2 = ibuf;

// Pipeline Registers (PREGS)
reg [2:0] preg_ins;
reg [4:0] preg_ad1;
reg [7:0] preg_ad2;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        preg_ins <= 3'd0;
        preg_ad1 <= 5'd0;
        preg_ad2 <= 8'd0;
    end else begin
        preg_ins <= idec_ins;
        preg_ad1 <= idec_ad1;
        preg_ad2 <= idec_ad2;
    end
end

// Output Logic (OUTLOGIC)
assign ins = preg_ins;
assign ad1 = preg_ad1;
assign ad2 = preg_ad2;

endmodule