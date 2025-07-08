module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count; // 3 bits enough for count down from 4 to 0

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;
            shift_ena <= 1'b1;
        end else if (count != 0) begin
            count <= count - 1'b1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end

endmodule