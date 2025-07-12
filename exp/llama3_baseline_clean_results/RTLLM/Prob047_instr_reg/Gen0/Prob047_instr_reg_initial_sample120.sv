module instr_reg(
    input clk, 
    input rst, 
    input [1:0] fetch, 
    input [7:0] data, 
    output [2:0] ins, 
    output [4:0] ad1, 
    output [7:0] ad2
);

// Define two 8-bit registers to store instructions from different sources
reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Always block to handle clock and reset signals
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        // Initialize both registers to zero on active low reset
        ins_p1 <= 8'b0;
        ins_p2 <= 8'b0;
    end else begin
        case (fetch)
            2'b01: begin
                // Fetch instruction from data input into ins_p1
                ins_p1 <= data;
            end
            2'b10: begin
                // Fetch instruction from data input into ins_p2
                ins_p2 <= data;
            end
            default: begin
                // Retain previous values if fetch signal is neither 2'b01 nor 2'b10
                ins_p1 <= ins_p1;
                ins_p2 <= ins_p2;
            end
        endcase
    end
end

// Assign output signals
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule