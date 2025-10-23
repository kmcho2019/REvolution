module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, enable shift_ena for 4 cycles
            counter <= 3'd4;
        end else if (counter != 3'd0) begin
            // Decrement counter if active
            counter <= counter - 1;
        end
        // else counter remains zero indefinitely
    end

    assign shift_ena = (counter != 3'd0);

endmodule