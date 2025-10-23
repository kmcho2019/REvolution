module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and byte storage logic
    always @(*) begin
        next_state = state; // Default: stay in current state
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                end
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Byte storage logic
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            case (state)
                IDLE: if (in[3]) byte1 <= in;
                BYTE1: byte2 <= in;
                BYTE2: byte3 <= in;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (state == BYTE2) ? {byte1, byte2, byte3} : 24'bx;
    assign done = (state == BYTE2);

endmodule