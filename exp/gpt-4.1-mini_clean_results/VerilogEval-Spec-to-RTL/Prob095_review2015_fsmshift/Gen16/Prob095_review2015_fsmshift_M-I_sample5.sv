module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;         // Initialize to 4 for exactly 4 cycles
        end else if (counter != 3'd0) begin
            counter <= counter - 1'b1;
        end
        // else hold at 0 to prevent toggling
    end

    assign shift_ena = (counter != 3'd0);

endmodule