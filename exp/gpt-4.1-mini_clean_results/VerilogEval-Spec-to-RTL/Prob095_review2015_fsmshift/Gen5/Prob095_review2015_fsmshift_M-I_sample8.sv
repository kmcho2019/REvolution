module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] ena_count;
    reg       reset_d;

    always @(posedge clk) begin
        reset_d <= reset; // synchronize and store previous reset

        if (~reset_d & reset) begin
            // Detect synchronous rising edge of reset
            ena_count <= 3'd1;
            shift_ena <= 1'b1;
        end else if (ena_count != 3'd0) begin
            if (ena_count < 3'd4) begin
                ena_count <= ena_count + 3'd1;
                shift_ena <= 1'b1;
            end else begin
                ena_count <= 3'd0;
                shift_ena <= 1'b0;
            end
        end else begin
            // shift_ena low and counter zero when not in enable cycle
            shift_ena <= 1'b0;
            ena_count <= 3'd0;
        end
    end

endmodule