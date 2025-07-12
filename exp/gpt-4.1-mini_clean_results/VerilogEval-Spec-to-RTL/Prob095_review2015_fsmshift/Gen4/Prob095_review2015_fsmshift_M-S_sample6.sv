module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 2'd4;      // Load 4 cycles on reset
        else if (count != 0)
            count <= count - 1; // Count down each cycle
    end

    assign shift_ena = (count != 0);

endmodule