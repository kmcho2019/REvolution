module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] state, next_state;
    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;
    parameter BYTE3 = 2'b11;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Output logic
    assign done = (state == BYTE3);

endmodule