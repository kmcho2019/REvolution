module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    // FSM state encoding (binary)
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;

    reg [7:0] byte1_reg, byte2_reg, byte3_reg;

    // Sequential logic: FSM state, byte registers, done and out_bytes
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1_reg <= 8'd0;
            byte2_reg <= 8'd0;
            byte3_reg <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1_reg <= in;
                    end
                end
                BYTE1: begin
                    byte2_reg <= in;
                end
                BYTE2: begin
                    byte3_reg <= in;
                    done <= 1'b1;
                    out_bytes <= {byte1_reg, byte2_reg, in};
                end
            endcase
        end
    end

    // Combinational next state logic: evaluate in[3] only in IDLE
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule