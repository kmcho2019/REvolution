module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] byte_shift_reg;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= in[3] ? BYTE1 : IDLE;
                BYTE1: state <= BYTE2;
                BYTE2: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Data storage (shift register)
    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'bx;
        end else begin
            case (state)
                IDLE:  if (in[3]) byte_shift_reg[23:16] <= in;
                BYTE1: byte_shift_reg[15:8] <= in;
                BYTE2: byte_shift_reg[7:0] <= in;
                default: byte_shift_reg <= 24'bx;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (state == BYTE2) ? {byte_shift_reg[23:16], byte_shift_reg[15:8], in} : 24'bx;
    assign done = (state == BYTE2);

endmodule