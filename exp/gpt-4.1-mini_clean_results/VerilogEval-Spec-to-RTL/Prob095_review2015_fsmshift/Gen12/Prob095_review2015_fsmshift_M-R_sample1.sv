module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;  // 3 bits to hold values from 0 to 4

    // Counter logic: on reset load 4, else decrement if not zero
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;
        end else if (count != 0) begin
            count <= count - 1;
        end
    end

    // shift_ena is asserted as long as count is not zero
    assign shift_ena = (count != 0);

endmodule