module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;  // load count = 4 on reset
        end else if (count != 0) begin
            count <= count - 1; // count down when nonzero
        end
        // else hold count at zero
    end

    assign shift_ena = (count != 0);

endmodule