module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [15:0] instruction_buffer;
    wire gated_clk = clk & (|fetch);  // Clock gating
    
    always @(posedge gated_clk or negedge rst) begin
        if (!rst) begin
            instruction_buffer <= 16'b0;
        end
        else begin
            case (fetch)
                2'b01: instruction_buffer[15:8] <= data;  // Store in upper byte
                2'b10: instruction_buffer[7:0] <= data;   // Store in lower byte
                default: ;  // Maintain current value
            endcase
        end
    end

    // Output registers for better timing
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end
        else begin
            {ins, ad1} <= instruction_buffer[15:8];
            ad2 <= instruction_buffer[7:0];
        end
    end

endmodule