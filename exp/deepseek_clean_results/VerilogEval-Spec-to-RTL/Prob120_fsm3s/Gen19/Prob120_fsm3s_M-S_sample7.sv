module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state; // A=00, B=01, C=10, D=11

    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;
        else case (state)
            2'b00: state <= in ? 2'b01 : 2'b00;
            2'b01: state <= in ? 2'b01 : 2'b10;
            2'b10: state <= in ? 2'b11 : 2'b00;
            2'b11: state <= in ? 2'b01 : 2'b10;
        endcase
    end

    assign out = (state == 2'b11);

endmodule