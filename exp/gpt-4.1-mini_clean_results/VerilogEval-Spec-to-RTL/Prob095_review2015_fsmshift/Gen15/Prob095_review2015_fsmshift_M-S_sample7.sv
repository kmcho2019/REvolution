module TopModule (
    input  wire clk,
    input  wire reset,   // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] counter; // 3 bits to count down from 4

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
        end else if (counter != 0) begin
            counter <= counter - 1'b1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule