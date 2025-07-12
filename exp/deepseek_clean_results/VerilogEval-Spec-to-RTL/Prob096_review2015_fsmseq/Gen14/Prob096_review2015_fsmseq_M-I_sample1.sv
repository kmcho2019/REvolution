module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    reg first_stage_match;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
            first_stage_match <= 1'b0;
        end else if (!found) begin
            // First stage: compare last 3 bits
            first_stage_match <= (shift_reg[2:0] == 3'b110);
            
            // Second stage: combine with new bit
            found <= first_stage_match && (data == 1'b1);
            
            // Update shift register only when needed
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_shifting = found;

endmodule