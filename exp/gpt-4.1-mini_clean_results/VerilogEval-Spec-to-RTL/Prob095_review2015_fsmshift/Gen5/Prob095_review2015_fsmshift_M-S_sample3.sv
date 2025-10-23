module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset)
            count <= 3'd4;      // Load 4 on reset
        else if (count != 0)
            count <= count - 1; // Count down each cycle
    end

    assign shift_ena = (count != 0);

endmodule