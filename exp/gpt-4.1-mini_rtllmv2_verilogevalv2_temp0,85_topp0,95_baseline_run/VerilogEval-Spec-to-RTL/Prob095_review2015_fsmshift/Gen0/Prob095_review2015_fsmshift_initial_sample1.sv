module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [1:0] count; // 2-bit counter sufficient for counting 0 to 3

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, enable shifting and reset counter
            shift_ena <= 1'b1;
            count <= 2'd0;
        end else if (shift_ena) begin
            // Count 4 clock cycles with shift_ena high
            if (count == 2'd3) begin
                shift_ena <= 1'b0;
                count <= count;
            end else begin
                count <= count + 1'b1;
            end
        end
        // Once shift_ena is 0, hold it low until reset
    end

endmodule