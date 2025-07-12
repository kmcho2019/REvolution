// instr_reg module
module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched
    input load_p1,     // Load signal for ins_p1
    input load_p2,     // Load signal for ins_p2

    output [7:0] ins_p1, // First 8-bit register to store instructions
    output [7:0] ins_p2  // Second 8-bit register to store instructions
);

reg [7:0] ins_p1_reg;  // First 8-bit register to store instructions
reg [7:0] ins_p2_reg;  // Second 8-bit register to store instructions

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ins_p1_reg <= 8'd0;
        ins_p2_reg <= 8'd0;
    end else begin
        if (load_p1) begin
            ins_p1_reg <= data;
        end
        if (load_p2) begin
            ins_p2_reg <= data;
        end
    end
end

assign ins_p1 = ins_p1_reg;
assign ins_p2 = ins_p2_reg;

endmodule

// instr_ctrl module
module instr_ctrl(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output load_p1,    // Load signal for ins_p1
    output load_p2     // Load signal for ins_p2
);

reg load_p1_reg;  // Load signal for ins_p1
reg load_p2_reg;  // Load signal for ins_p2

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        load_p1_reg <= 1'b0;
        load_p2_reg <= 1'b0;
    end else begin
        case (fetch)
            2'b01: load_p1_reg <= 1'b1;
            2'b10: load_p2_reg <= 1'b1;
            default: begin
                load_p1_reg <= 1'b0;
                load_p2_reg <= 1'b0;
            end
        endcase
    end
end

assign load_p1 = load_p1_reg;
assign load_p2 = load_p2_reg;

endmodule

// top module
module instr_reg_top(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

wire load_p1;
wire load_p2;
wire [7:0] ins_p1;
wire [7:0] ins_p2;

instr_ctrl u_ctrl(
    .clk(clk),
    .rst(rst),
    .fetch(fetch),
    .data(data),
    .load_p1(load_p1),
    .load_p2(load_p2)
);

instr_reg u_reg(
    .clk(clk),
    .rst(rst),
    .fetch(fetch),
    .data(data),
    .load_p1(load_p1),
    .load_p2(load_p2),
    .ins_p1(ins_p1),
    .ins_p2(ins_p2)
);

assign ins = ins_p1[7:5];  // High 3 bits of the instruction in ins_p1
assign ad1 = ins_p1[4:0];  // Low 5 bits of the instruction in ins_p1
assign ad2 = ins_p2;       // Full 8-bit data from ins_p2

endmodule