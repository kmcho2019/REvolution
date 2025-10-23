module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = (in[3]) ? BYTE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign done = (current_state == BYTE3);

endmodule