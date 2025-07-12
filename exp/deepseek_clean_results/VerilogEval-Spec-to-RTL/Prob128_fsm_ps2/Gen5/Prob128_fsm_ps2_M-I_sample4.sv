module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] state;  // Binary encoding: 00=waiting, 01=byte1, 10=byte2

    // Combinational done output
    assign done = (state == 2'b10);  // Assert done when in byte2 state

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to waiting state
        end else begin
            case (state)
                2'b00: state <= in[3] ? 2'b01 : 2'b00;  // Waiting -> Byte1 if in[3]=1
                2'b01: state <= 2'b10;                  // Byte1 -> Byte2
                2'b10: state <= 2'b00;                  // Byte2 -> Waiting (message complete)
            endcase
        end
    end

endmodule