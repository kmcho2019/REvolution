module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] shift_reg;

    // Sequential logic for state, shift register, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 24'b0;
            done      <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // load first byte at MSB
                        shift_reg <= {in, 16'b0};
                    end
                end
                BYTE2: begin
                    // shift existing bytes left by 8 and insert new byte at LSB
                    shift_reg <= {shift_reg[15:0], in};
                end
                BYTE3: begin
                    // shift again and output done
                    shift_reg <= {shift_reg[15:0], in};
                    done <= 1'b1;
                end
            endcase

            if (done) begin
                out_bytes <= shift_reg;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule