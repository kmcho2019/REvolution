module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // 2-bit counter for 4 clock cycles
    reg [2:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start counting from 1
            cycle_count <= 3'd1;
            shift_ena <= 1'b1;
        end else begin
            if (cycle_count != 0 && cycle_count < 4) begin
                cycle_count <= cycle_count + 1;
                shift_ena <= 1'b1;
            end else if (cycle_count == 4) begin
                // After 4 cycles disable shift_ena and stop counting
                cycle_count <= 3'd0;
                shift_ena <= 1'b0;
            end else begin
                // Remain idle with shift_ena low
                shift_ena <= 1'b0;
            end
        end
    end

endmodule