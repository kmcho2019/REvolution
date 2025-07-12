module instr_reg(
    input clk,
    input rst_n,  // Active low reset
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

reg [7:0] ins_p1;  // Register to store instruction from first source
reg [7:0] ins_p2;  // Register to store instruction from second source

// Assign outputs
assign ins = ins_p1[7:5];  // High 3 bits for opcode
assign ad1 = ins_p1[4:0];  // Low 5 bits for register address
assign ad2 = ins_p2;       // Full 8-bit data from the second source

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Active low reset
        ins_p1 <= 8'b0;  // Initialize ins_p1 to zero
        ins_p2 <= 8'b0;  // Initialize ins_p2 to zero
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;  // Fetch into ins_p1
            2'b10: ins_p2 <= data;  // Fetch into ins_p2
            default: ;  // Retain previous values
        endcase
    end
end

endmodule