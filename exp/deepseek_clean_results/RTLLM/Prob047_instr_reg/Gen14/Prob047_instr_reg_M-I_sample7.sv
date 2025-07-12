module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers
    reg [7:0] ins_p1, ins_p2;

    // Single-edge capture logic with clear functionality
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            // Capture from source 1 (register)
            if (fetch == 2'b01) begin
                ins_p1 <= data;
                ins <= data[7:5];  // Direct output assignment
                ad1 <= data[4:0];  // No additional register needed
            end
            
            // Capture from source 2 (RAM/ROM)
            if (fetch == 2'b10) begin
                ins_p2 <= data;
                ad2 <= data;       // Direct output assignment
            end
            
            // Note: No else clause - retains previous values when no fetch
        end
    end

    /* Functional Description:
     * - Single clock domain design for better timing
     * - Outputs update immediately with register contents
     * - Clear separation of source handling
     * - Minimal register usage while maintaining functionality
     * - Reset initializes all registers
     */
endmodule