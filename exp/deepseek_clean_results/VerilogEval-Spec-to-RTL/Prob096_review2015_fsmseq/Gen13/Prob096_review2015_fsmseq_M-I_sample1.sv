module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits
    reg found;
    reg partial_match;    // Pipeline stage for sequence detection

    wire shift_enable = !found;  // Freeze shifting after detection

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            found <= 1'b0;
            partial_match <= 1'b0;
        end else if (shift_enable) begin
            // First stage: detect '110' in shift_reg
            partial_match <= (shift_reg == 3'b110);
            
            // Second stage: check if next bit completes '1101'
            found <= partial_match && (data == 1'b1);
            
            // Update shift register
            shift_reg <= {shift_reg[1:0], data};
        end else begin
            // Maintain found state until reset
            found <= found;
        end
    end

    assign start_shifting = found;

endmodule