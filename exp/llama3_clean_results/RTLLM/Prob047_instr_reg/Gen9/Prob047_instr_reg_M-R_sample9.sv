module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

reg [7:0] ins_p1;  // First 8-bit register
reg [7:0] ins_p2;  // Second 8-bit register

// Sequential logic for updating the registers
always @ (posedge clk) begin
    if (~rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
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

// Combinational logic for deriving outputs
always @ (*) begin
    case (fetch)
        2'b01: begin
            ins = ins_p1[7:5];
            ad1 = ins_p1[4:0];
            ad2 = 8'd0;
        end
        2'b10: begin
            ins = ins_p2[7:5];
            ad1 = ins_p2[4:0];
            ad2 = data;
        end
        default: begin
            ins = 3'd0;
            ad1 = 5'd0;
            ad2 = 8'd0;
        end
    endcase
end

endmodule