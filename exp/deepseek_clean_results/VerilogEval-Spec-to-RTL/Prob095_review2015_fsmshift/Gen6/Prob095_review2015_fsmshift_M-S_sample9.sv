module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] count;  // 2-bit counter (0-3)

    always @(posedge clk) begin
        count <= reset ? 2'b00 : count + 1;
    end

    assign shift_ena = ~count[1];  // Active for counts 0-3 (4 cycles)

endmodule