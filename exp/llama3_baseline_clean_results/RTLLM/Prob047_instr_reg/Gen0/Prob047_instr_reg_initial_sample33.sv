module instr_reg (
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Initialize registers on reset
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        // Update registers based on fetch signal
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: begin
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Derive outputs from stored instructions
always @(*) begin
    ins = ins_p1[7:5]; // High 3 bits of ins_p1
    ad1 = ins_p1[4:0]; // Low 5 bits of ins_p1
    ad2 = ins_p2;     // Full 8-bit data from ins_p2
end

endmodule