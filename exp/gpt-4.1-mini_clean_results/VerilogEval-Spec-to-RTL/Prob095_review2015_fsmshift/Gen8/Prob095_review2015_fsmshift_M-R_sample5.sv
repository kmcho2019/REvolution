module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high reset
    output wire shift_ena
);

    reg [2:0] counter; // 3 bits to count down from 4 to 0

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    // Continuous assignment ensures shift_ena immediately reflects counter state
    assign shift_ena = (counter != 0);

endmodule