module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Instruction storage registers
    reg [7:0] current_ins;
    reg [7:0] next_ins;
    reg [7:0] source2_data;
    
    // Internal signals for instruction components
    wire [2:0] next_ins_opcode;
    wire [4:0] next_ins_addr;
    
    // Assign instruction components
    assign next_ins_opcode = next_ins[7:5];
    assign next_ins_addr = next_ins[4:0];
    
    // Sequential block for register updates
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_ins <= 8'b0;
            next_ins <= 8'b0;
            source2_data <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            // Pipeline stage 1: Capture new instructions
            case (fetch)
                2'b01: current_ins <= data;
                2'b10: source2_data <= data;
                default: begin
                    current_ins <= current_ins;
                    source2_data <= source2_data;
                end
            endcase
            
            // Pipeline stage 2: Process and output
            next_ins <= current_ins;
            ins <= next_ins_opcode;
            ad1 <= next_ins_addr;
            ad2 <= source2_data;
        end
    end

endmodule