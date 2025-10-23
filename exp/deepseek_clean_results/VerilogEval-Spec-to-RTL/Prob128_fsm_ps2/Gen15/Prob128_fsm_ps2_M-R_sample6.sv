module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign done = (state == BYTE3);

endmodule