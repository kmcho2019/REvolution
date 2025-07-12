module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [2:0] count;  // 3-bit counter to count 0-4

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b000;
        end else if (count < 3'b100) begin
            count <= count + 1;
        end
    end

    assign shift_ena = (count < 3'b100);

endmodule