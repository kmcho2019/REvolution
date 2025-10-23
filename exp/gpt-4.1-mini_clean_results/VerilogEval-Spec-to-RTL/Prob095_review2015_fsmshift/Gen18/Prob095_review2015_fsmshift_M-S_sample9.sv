module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 3'd4;
        else if (counter != 0)
            counter <= counter - 1;

        shift_ena <= (counter != 0);
    end

endmodule