module TopModule (
    input  wire clk,
    input  wire reset,       // synchronous active high
    output wire shift_ena
);

    reg [2:0] count;  // 3 bits enough to count 0 to 4

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
        end else if (count < 3'd4) begin
            count <= count + 1'b1;
        end
    end

    assign shift_ena = (count < 3'd4);

endmodule