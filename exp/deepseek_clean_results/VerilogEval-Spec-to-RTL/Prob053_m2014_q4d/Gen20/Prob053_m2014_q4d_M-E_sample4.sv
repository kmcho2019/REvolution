module TopModule (
    input clk,
    input in,
    output reg out
);

    wire t_input = in;  // T flip-flop input is the module input

    always @(posedge clk) begin
        if (t_input) begin
            out <= ~out;  // Toggle when input is high
        end
        // Else maintain state (implicit in the register)
    end

endmodule