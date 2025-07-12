module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;
    reg active; // Indicates shift_ena active period

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            active <= 1'b0;
            shift_ena <= 1'b0;  // No shift enable during reset
        end else begin
            if (!active) begin
                // Start 4-cycle enable period immediately after reset
                active <= 1'b1;
                count <= 3'd1;
                shift_ena <= 1'b1;
            end else if (count < 3'd4) begin
                count <= count + 1;
                shift_ena <= 1'b1;
            end else begin
                // After 4 cycles, disable shift_ena indefinitely
                shift_ena <= 1'b0;
                // active remains high or could be cleared - no further enable until reset
            end
        end
    end

endmodule