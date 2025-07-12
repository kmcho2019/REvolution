module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Shift register stores last 4 bits
reg [3:0] shift_reg;
reg data_in_prev;

// Input change detection
wire input_changed = (data_in != data_in_prev);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        data_in_prev <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Only update when input changes to save power
        if (input_changed) begin
            shift_reg <= {shift_reg[2:0], data_in};
            data_in_prev <= data_in;
            
            // Registered output for glitch-free operation
            sequence_detected <= (shift_reg == 4'b1001);
        end
    end
end

endmodule