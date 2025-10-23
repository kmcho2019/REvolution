module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM state encoding
    localparam IDLE  = 2'd0,
               BYTE2 = 2'd1,
               BYTE3 = 2'd2;

    reg [1:0] state;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;  // done asserted one cycle only

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {16'd0, in};  // store first byte
                        state <= BYTE2;
                    end
                end

                BYTE2: begin
                    shift_reg <= {shift_reg[15:0], in};  // shift in second byte
                    state <= BYTE3;
                end

                BYTE3: begin
                    shift_reg <= {shift_reg[15:0], in};  // shift in third byte
                    out_bytes <= {shift_reg[15:0], in};  // output message
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule