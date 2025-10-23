module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    reg [1:0] state, next_state;
    reg store_byte1, store_byte2, store_byte3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Byte storage control
    always @(*) begin
        store_byte1 = (state == IDLE) && in[3];
        store_byte2 = (state == BYTE1);
        store_byte3 = (state == BYTE2);
    end

    // Data storage
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
        end else begin
            if (store_byte1) out_bytes[23:16] <= in;
            if (store_byte2) out_bytes[15:8] <= in;
            if (store_byte3) out_bytes[7:0] <= in;
        end
    end

    // Done signal generation
    assign done = (state == BYTE3);

endmodule