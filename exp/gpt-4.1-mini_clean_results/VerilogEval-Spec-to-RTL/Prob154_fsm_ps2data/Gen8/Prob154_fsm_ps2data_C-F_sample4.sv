module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states encoding
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] byte1, byte2;

    // Load enables reduce toggling on registers
    wire load_byte1 = (state == IDLE) && in[3];
    wire load_byte2 = (state == BYTE1);
    wire load_byte3 = (state == BYTE2);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            if (load_byte1)
                byte1 <= in;

            if (load_byte2)
                byte2 <= in;

            if (load_byte3) begin
                // On third byte, output concatenated message and assert done
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    // Next state combinational logic; only in IDLE check in[3]
    always @(*) begin
        case(state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule