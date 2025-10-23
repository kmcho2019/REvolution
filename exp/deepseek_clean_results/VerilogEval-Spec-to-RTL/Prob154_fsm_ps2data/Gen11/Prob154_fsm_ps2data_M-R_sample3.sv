module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] data_reg;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 24'bx;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE:  if (in[3]) data_reg[23:16] <= in;
                BYTE1: data_reg[15:8] <= in;
                BYTE2: data_reg[7:0] <= in;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (state == BYTE2) ? data_reg : 24'bx;
    assign done = (state == BYTE2);

endmodule