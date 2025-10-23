module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;       // Start counting on reset cycle itself
        end else if (count < 3'd4) begin
            count <= count + 1'b1; // Increment until 4 cycles elapsed
        end
        // else retain count at 4 to keep shift_ena low forever
    end

    assign shift_ena = (count < 3'd4); // Assert for exactly 4 cycles starting with reset

endmodule