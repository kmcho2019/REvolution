module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    reg first_stage_match;  // Pipeline stage for comparison

    // Enable signal for shift register (freeze after detection)
    wire shift_enable = !found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
            first_stage_match <= 1'b0;
        end else if (shift_enable) begin
            // First pipeline stage: check first 3 bits
            first_stage_match <= (shift_reg[2:0] == 3'b110);
            
            // Second pipeline stage: combine with new data
            found <= first_stage_match && (data == 1'b1);
            
            // Shift register update
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_shifting = found;

endmodule