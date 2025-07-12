module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // States as a 2-bit counter: 0 = waiting for start byte, 1 = byte 2, 2 = byte 3
    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= (state == 2'b10);  // done asserted immediately after third byte received
        end
    end

    always @(*) begin
        case (state)
            2'b00: next_state = in[3] ? 2'b01 : 2'b00; // wait for byte 1 with in[3]=1
            2'b01: next_state = 2'b10;                  // received byte 2
            2'b10: next_state = 2'b00;                  // received byte 3, then go back to wait
            default: next_state = 2'b00;
        endcase
    end

endmodule