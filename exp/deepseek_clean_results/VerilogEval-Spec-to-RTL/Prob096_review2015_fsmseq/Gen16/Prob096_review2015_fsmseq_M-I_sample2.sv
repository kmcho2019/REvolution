module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // Reduced to 3 bits for first stage comparison
    reg first_stage_match;
    reg found;
    wire shift_enable;

    // Clock gating control
    assign shift_enable = !found;

    // First stage: compare first 3 bits (110)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            first_stage_match <= 1'b0;
        end else if (shift_enable) begin
            shift_reg <= {shift_reg[1:0], data};
            first_stage_match <= (shift_reg == 3'b110);
        end
    end

    // Second stage: final bit comparison (1)
    always @(posedge clk) begin
        if (reset) begin
            found <= 1'b0;
        end else if (shift_enable) begin
            found <= first_stage_match && data;
        end
    end

    assign start_shifting = found;

endmodule