module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;    // Load counter to 4 on reset
        end else if (count != 0) begin
            count <= count - 1; // Decrement count each clock while > 0
        end
        // else count stays at 0 forever until reset
    end

    // shift_ena is asserted while count > 0, exactly 4 cycles after reset
    assign shift_ena = (count != 0);

endmodule