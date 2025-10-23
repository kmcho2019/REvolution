module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding using localparam for clarity
    localparam IDLE = 2'd0,
               BYTE2 = 2'd1,
               BYTE3 = 2'd2;

    reg [1:0] state, next_state;

    // State transition sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:    next_state = in[3] ? BYTE2 : IDLE;
            BYTE2:   next_state = BYTE3;
            BYTE3:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Done signal combinational logic: asserted one cycle after receiving 3rd byte
    assign done = (state == BYTE3);

endmodule