module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Pipeline stage 1 registers
    reg [7:0] barrel_reg;
    reg [7:0] pos_mask;  // Thermometer-coded position indicator
    reg will_complete;

    // Pipeline stage 2 registers
    reg [7:0] out_reg;
    reg valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Stage 1 reset
            barrel_reg <= 8'b0;
            pos_mask <= 8'b00000001;
            will_complete <= 1'b0;
            
            // Stage 2 reset
            out_reg <= 8'b0;
            valid_reg <= 1'b0;
        end
        else begin
            // Default assignments
            valid_reg <= 1'b0;
            will_complete <= 1'b0;

            // Pipeline Stage 1: Barrel Shifter Update
            if (din_valid) begin
                // Rotate position mask
                pos_mask <= {pos_mask[6:0], pos_mask[7]};
                
                // Update barrel register at current position
                barrel_reg <= barrel_reg | (pos_mask & {8{din_serial}});
                
                // Predict if next input will complete the byte
                will_complete <= &pos_mask[6:0];
            end

            // Pipeline Stage 2: Output Generation
            if (will_complete) begin
                out_reg <= barrel_reg | (pos_mask & {8{din_serial}});
                valid_reg <= 1'b1;
                
                // Clear barrel register for next byte
                if (din_valid) begin
                    barrel_reg <= 8'b0;
                    pos_mask <= 8'b00000001;
                end
            end
        end
    end

    // Output assignments
    always @(*) begin
        dout_parallel = out_reg;
        dout_valid = valid_reg;
    end

endmodule