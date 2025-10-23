module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] counter;

    // Counter update logic
    always @(posedge clk) begin
        if (reset)
            counter <= 2'b11;  // Initialize to 3 (for 4 cycles)
        else if (counter != 0)
            counter <= counter - 1;
    end

    // Output logic
    assign shift_ena = (counter != 0);

endmodule