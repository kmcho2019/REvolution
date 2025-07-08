module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] count; // 3 bits enough to count to 4

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