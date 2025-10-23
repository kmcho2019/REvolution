module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd3;         // Initialize to 3 for exact 4 cycles assertion
        end else if (counter != 0) begin
            counter <= counter - 1'b1;
        end
        // else hold at 0, no change to avoid toggling
    end

    assign shift_ena = (counter != 3'd0);

endmodule