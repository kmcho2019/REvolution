module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active high
    output wire shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;          // Load 4 on synchronous reset
        end else if (count != 0) begin
            count <= count - 1;     // Decrement counter until zero
        end
        // else count stays at 0
    end

    assign shift_ena = (count != 0);

endmodule