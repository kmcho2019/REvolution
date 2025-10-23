module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] count;  // 2-bit counter for 0-3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b00;
        end else if (count != 2'b11) begin
            count <= count + 1;
        end
    end

    assign shift_ena = (count != 2'b11) | reset;

endmodule