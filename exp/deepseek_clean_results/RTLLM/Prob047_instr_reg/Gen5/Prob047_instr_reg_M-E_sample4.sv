module instr_reg #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 3,
    parameter ADDR_WIDTH = 5
)(
    input clk,
    input rst,
    input [1:0] fetch,
    input [DATA_WIDTH-1:0] data,
    output reg [OPCODE_WIDTH-1:0] ins,
    output reg [ADDR_WIDTH-1:0] ad1,
    output reg [DATA_WIDTH-1:0] ad2
);

    // Unified register storage with write enables
    reg [DATA_WIDTH-1:0] instruction_reg [0:1];
    wire [1:0] write_en;

    // Priority encoder for fetch signals
    assign write_en[0] = fetch[0] & ~fetch[1]; // Priority to p1 if both set
    assign write_en[1] = fetch[1];

    // Register update logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            instruction_reg[0] <= 0;
            instruction_reg[1] <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
        end
        else begin
            // Update instruction registers only when needed
            if (write_en[0]) instruction_reg[0] <= data;
            if (write_en[1]) instruction_reg[1] <= data;
            
            // Registered outputs for better timing
            ins <= instruction_reg[0][DATA_WIDTH-1:DATA_WIDTH-OPCODE_WIDTH];
            ad1 <= instruction_reg[0][ADDR_WIDTH-1:0];
            ad2 <= instruction_reg[1];
        end
    end

endmodule