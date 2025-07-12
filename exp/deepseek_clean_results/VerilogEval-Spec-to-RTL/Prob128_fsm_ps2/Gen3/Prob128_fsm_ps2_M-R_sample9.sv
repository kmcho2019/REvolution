module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:   next_state = in[3] ? BYTE1 : IDLE;
            BYTE1:  next_state = BYTE2;
            BYTE2:  next_state = BYTE3;
            BYTE3: next_state = in[3] ? BYTE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic (combinational)
    assign done = (state == BYTE3);

endmodule