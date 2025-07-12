module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Parameters for bit positions
    parameter OPCODE_HI = 7;
    parameter OPCODE_LO = 5;
    parameter ADDR_HI   = 4;
    parameter ADDR_LO   = 0;

    // Unified storage register
    reg [15:0] instruction_store = 16'b0;
    wire write_enable = |fetch;  // OR reduction of fetch
    
    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & write_enable;

    // Register update logic
    always @(posedge gated_clk or negedge rst) begin
        if (!rst) begin
            instruction_store <= 16'b0;
        end else begin
            case (fetch)
                2'b01: instruction_store[15:8] <= data;  // Update upper byte
                2'b10: instruction_store[7:0]  <= data;  // Update lower byte
                default: ;  // No update
            endcase
        end
    end

    // Output register stage for better timing
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            ins <= instruction_store[OPCODE_HI:OPCODE_LO];
            ad1 <= instruction_store[ADDR_HI:ADDR_LO];
            ad2 <= instruction_store[7:0];
        end
    end

endmodule