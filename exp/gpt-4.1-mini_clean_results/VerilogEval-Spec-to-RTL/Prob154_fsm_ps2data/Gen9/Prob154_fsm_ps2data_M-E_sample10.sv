module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot encoded FSM states (3 bits)
    localparam SEARCH = 3'b001;
    localparam BYTE2  = 3'b010;
    localparam BYTE3  = 3'b100;

    reg [2:0] state, next_state;

    // 24-bit register to hold the three bytes: [23:16] first, [15:8] second, [7:0] third
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default no done, set below on third byte receive

            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        shift_reg[23:16] <= in; // load first byte
                    end
                end
                BYTE2: begin
                    shift_reg[15:8] <= in;  // load second byte
                end
                BYTE3: begin
                    shift_reg[7:0] <= in;   // load third byte
                    done <= 1'b1;
                    out_bytes <= {shift_reg[23:16], shift_reg[15:8], in};
                end
                default: ; // no action
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            SEARCH: next_state = in[3] ? BYTE2 : SEARCH;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = SEARCH;
            default: next_state = SEARCH;
        endcase
    end

endmodule