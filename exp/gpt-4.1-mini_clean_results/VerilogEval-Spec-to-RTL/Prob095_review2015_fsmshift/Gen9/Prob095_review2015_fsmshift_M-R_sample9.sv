module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    reg [2:0] count;

    // Counter counts down from 4 on reset and runs down to 0, shift_ena asserted while count != 0
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;  // Load count = 4 on synchronous reset
        end else if (count != 0) begin
            count <= count - 1'b1; // Decrement count until zero
        end
    end

    assign shift_ena = (count != 0);

endmodule