module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // State encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] bytes_reg;

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
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Byte storage logic
    always @(posedge clk) begin
        if (reset) begin
            bytes_reg <= 24'bx;
        end else begin
            case (state)
                IDLE:  if (in[3]) bytes_reg[23:16] <= in;
                BYTE1: bytes_reg[15:8] <= in;
                BYTE2: bytes_reg[7:0] <= in;
                default: bytes_reg <= bytes_reg;
            endcase
        end
    end

    // Output assignments
    assign done = (state == BYTE2);
    assign out_bytes = done ? bytes_reg : 24'bx;

endmodule