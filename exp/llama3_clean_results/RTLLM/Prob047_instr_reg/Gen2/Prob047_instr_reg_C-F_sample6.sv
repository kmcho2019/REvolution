module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Internal registers to store instructions
reg [7:0] ins_p1;  
reg [7:0] ins_p2;  

// Clock gating signal
reg clk_gate;

// Clock gating logic
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        clk_gate <= 1'b0;
    end
    else begin
        case (fetch)
            2'b01: clk_gate <= 1'b1;
            2'b10: clk_gate <= 1'b1;
            default: clk_gate <= 1'b0;
        endcase
    end
end

// Reset logic
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        // Initialize registers to zero on reset
        ins_p1 <= 8'd0; 
        ins_p2 <= 8'd0; 
    end
    else if (clk_gate) begin
        case (fetch)
            2'b01: ins_p1 <= data; // Fetch instruction into ins_p1 when fetch is 2'b01
            2'b10: ins_p2 <= data; // Fetch instruction into ins_p2 when fetch is 2'b10
            default: begin
                // Retain previous values if fetch condition is not met
                ins_p1 <= ins_p1; 
                ins_p2 <= ins_p2; 
            end
        endcase
    end
end

// Output logic
assign ins = ins_p1[7:5];  // High 3 bits of the instruction in ins_p1
assign ad1 = ins_p1[4:0];  // Low 5 bits of the instruction in ins_p1
assign ad2 = ins_p2;       // Full 8-bit data from ins_p2

endmodule