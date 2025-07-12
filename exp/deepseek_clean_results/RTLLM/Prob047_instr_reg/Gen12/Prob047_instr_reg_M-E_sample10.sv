module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // 4-stage shift register buffer with power gating
    reg [7:0] instr_buffer [0:3];
    reg [3:0] buffer_active;
    
    // Field extraction masks (configurable)
    reg [7:0] opcode_mask = 8'b11100000;
    reg [7:0] addr1_mask  = 8'b00011111;
    reg [7:0] addr2_mask  = 8'b11111111;
    
    // Field swap configuration
    reg [1:0] field_swap = 2'b00; // 00:normal, 01:swap ad1/ad2, 10:ins=ad2[7:5]
    
    // Buffer control logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (integer i = 0; i < 4; i = i + 1)
                instr_buffer[i] <= 8'b0;
            buffer_active <= 4'b0001;
        end else begin
            // Shift buffer
            instr_buffer[3] <= instr_buffer[2];
            instr_buffer[2] <= instr_buffer[1];
            instr_buffer[1] <= instr_buffer[0];
            
            // Capture new data based on fetch signal
            case (fetch)
                2'b01: instr_buffer[0] <= data;
                2'b10: instr_buffer[1] <= data;
                default: ; // Maintain current values
            endcase
            
            // Update active stages
            buffer_active <= {buffer_active[2:0], |fetch};
        end
    end
    
    // Dynamic field extraction and swapping
    always @(*) begin
        // Default field assignments
        ins = (instr_buffer[0] & opcode_mask) >> 5;
        ad1 = instr_buffer[0] & addr1_mask;
        ad2 = instr_buffer[1] & addr2_mask;
        
        // Field swapping modes
        case (field_swap)
            2'b01: begin // Swap ad1 and ad2
                {ad1, ad2} = {ad2[4:0], {3'b0, ad1}};
            end
            2'b10: begin // ins from ad2
                ins = ad2[7:5];
            end
            default: ; // Normal operation
        endcase
    end
    
    // Power gating control (simplified for clarity)
    // In real implementation would control clock trees/power switches
    wire [3:0] power_gate = ~buffer_active;
    
endmodule