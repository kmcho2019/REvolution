module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 3'd4;       // Start at 4 for 4 cycles assertion
        else if (counter != 0)
            counter <= counter - 1;
    end

    assign shift_ena = (counter != 0);

endmodule