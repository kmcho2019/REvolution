module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State register: 0 = copy mode, 1 = invert mode
    reg invert_mode;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset state: return to copy mode, output 0
            invert_mode <= 1'b0;
            z <= 1'b0;
        end else begin
            if (invert_mode) begin
                // Invert mode: output inverted bits
                z <= ~x;
            end else begin
                // Copy mode: output bits as-is until first '1'
                z <= x;
                // Transition to invert mode after first '1'
                invert_mode <= x;
            end
        end
    end

endmodule