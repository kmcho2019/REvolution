module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] bit_pos;  // One-hot encoded position
    reg [WIDTH-1:0] shift_reg;
    reg [WIDTH-1:0] shift_reg_next;
    
    // Clock gating control
    wire shift_enable = din_valid;
    
    always @(*) begin
        if (shift_enable) begin
            shift_reg_next = {shift_reg[WIDTH-2:0], din_serial};
        end else begin
            shift_reg_next = shift_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_pos <= {{WIDTH-1{1'b0}}, 1'b1};  // Initialize to first bit
            shift_reg <= {WIDTH{1'b0}};
            dout_valid <= 1'b0;
            dout_parallel <= {WIDTH{1'b0}};
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;
            
            // Shift register update with clock gating
            if (shift_enable) begin
                shift_reg <= shift_reg_next;
                
                // Update bit position
                if (bit_pos[WIDTH-1]) begin
                    bit_pos <= {{WIDTH-1{1'b0}}, 1'b1};  // Reset to first bit
                    dout_parallel <= shift_reg_next;
                    dout_valid <= 1'b1;
                end else begin
                    bit_pos <= {bit_pos[WIDTH-2:0], 1'b0};  // Shift left
                end
            end
        end
    end

endmodule