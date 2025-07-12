module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] reset_count;

    always @(posedge clk) begin
        if (reset) begin
            // During reset: increment counter until 4 cycles are counted
            if (reset_count < 3'd4) begin
                reset_count <= reset_count + 3'd1;
                shift_ena <= 1'b1;
            end else begin
                // After 4 cycles of reset, keep shift_ena low even if reset continues
                shift_ena <= 1'b0;
            end
        end else begin
            // When reset is deasserted, clear counter and disable shift_ena forever
            reset_count <= 3'd0;
            shift_ena <= 1'b0;
        end
    end

endmodule