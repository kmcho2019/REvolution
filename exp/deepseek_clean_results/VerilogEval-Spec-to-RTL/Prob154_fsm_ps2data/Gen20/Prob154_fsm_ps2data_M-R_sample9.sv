module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Binary state encoding
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Byte capture logic
    always @(posedge clk) begin
        if (state == IDLE && in[3])
            out_bytes[23:16] <= in;
        else if (state == BYTE2)
            out_bytes[15:8] <= in;
        else if (state == BYTE3)
            out_bytes[7:0] <= in;
    end

    // Combinational done signal
    assign done = (state == BYTE3);

endmodule