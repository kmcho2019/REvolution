module instr_reg(
    input clk,
    input rst_n, // Active high reset for simplicity and consistency
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: begin
                // No explicit default action needed; 
                // ins_p1 and ins_p2 will retain their values
            end
        endcase
    end
end

// Direct assignments without additional logic to reduce area and power
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule