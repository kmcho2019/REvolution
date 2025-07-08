module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;
        end else if (count != 3'd0) begin
            count <= count - 1;
        end
    end

    always @(posedge clk) begin
        shift_ena <= (count != 3'd0);
    end

endmodule