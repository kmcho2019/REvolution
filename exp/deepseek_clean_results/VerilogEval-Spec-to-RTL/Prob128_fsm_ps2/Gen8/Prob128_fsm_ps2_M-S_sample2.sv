module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] state;  // 00: waiting, 01: byte1, 10: byte2

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= in[3] ? 2'b01 : 2'b00;  // waiting -> byte1 if in[3]=1
                2'b01: state <= 2'b10;                  // byte1 -> byte2
                2'b10: state <= 2'b00;                  // byte2 -> waiting
                default: state <= 2'b00;
            endcase
        end
    end

    assign done = (state == 2'b10);  // done when in byte2 state (next cycle returns to waiting)

endmodule