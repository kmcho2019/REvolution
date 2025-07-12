module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2,
    output reg ins_valid,
    output reg ad1_valid,
    output reg ad2_valid
);

    // Configuration registers
    reg [7:0] ins_mask = 8'b11100000;  // Default: bits 7-5
    reg [7:0] ad1_mask = 8'b00011111;  // Default: bits 4-0
    reg [7:0] ad2_mask = 8'b11111111;  // Default: all bits

    // Shift register and control
    reg [15:0] shift_reg;  // Double buffer for safety
    reg [3:0] shift_count;
    reg shift_enable;
    reg parity_error;

    // Field extraction logic
    wire [7:0] current_byte = shift_reg[7:0];
    wire [7:0] next_byte = shift_reg[15:8];
    
    // Parity calculation
    wire current_parity = ^current_byte;
    wire expected_parity = current_byte[0];  // Using LSB as parity bit

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 0;
            shift_count <= 0;
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
            ins_valid <= 0;
            ad1_valid <= 0;
            ad2_valid <= 0;
            parity_error <= 0;
        end else begin
            // Shift control logic
            if (|fetch) begin
                shift_enable <= 1;
                shift_reg <= {shift_reg[7:0], data};
                shift_count <= shift_count + 1;
            end else begin
                shift_enable <= 0;
            end

            // Field extraction when complete
            if (shift_count >= 1) begin
                parity_error <= current_parity != expected_parity;
                
                if (!parity_error) begin
                    // Dynamic field extraction using masks
                    ins <= |(current_byte & ins_mask[7:5]) >> 5;
                    ad1 <= |(current_byte & ad1_mask[4:0]);
                    
                    // Second byte handling
                    if (shift_count >= 2) begin
                        ad2 <= next_byte & ad2_mask;
                        ad2_valid <= 1;
                    end
                    
                    ins_valid <= 1;
                    ad1_valid <= 1;
                end
            end
            
            // Reset valid flags if no new data
            if (!shift_enable) begin
                ins_valid <= 0;
                ad1_valid <= 0;
                ad2_valid <= 0;
            end
        end
    end

    // Configuration interface (could be expanded)
    task set_field_masks;
        input [7:0] new_ins_mask;
        input [7:0] new_ad1_mask;
        input [7:0] new_ad2_mask;
        begin
            ins_mask = new_ins_mask;
            ad1_mask = new_ad1_mask;
            ad2_mask = new_ad2_mask;
        end
    endtask

endmodule