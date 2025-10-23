module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    reg partial_match;  // Registered partial match for 110 pattern

    // Clock gating logic for shift register
    wire shift_enable = !found;
    wire gated_clk = clk & shift_enable;

    // First stage: Check for 110 in last 3 bits
    wire current_partial_match = (shift_reg[2:0] == 3'b110);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
            partial_match <= 1'b0;
        end else begin
            // Register partial match result
            partial_match <= current_partial_match;
            
            // Final detection (registered partial match + current data)
            if (!found) begin
                found <= partial_match && (data == 1'b1);
            end
        end
    end

    // Shift register updates only when enabled
    always @(posedge gated_clk) begin
        if (!reset) begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_shifting = found;

endmodule