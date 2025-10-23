module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready signal
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state, next_state;

    reg [4:0] ctr;                  // 5-bit counter (0 to 16)
    reg signed [15:0] multiplicand_shifted;
    reg [15:0] multiplier_ext;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = RUN;
            RUN:  next_state = (ctr == 5'd16) ? IDLE : RUN;
            default: next_state = IDLE;
        endcase
    end

    // Counter update
    always @(posedge clk or posedge reset) begin
        if (reset)
            ctr <= 5'd0;
        else begin
            case (state)
                IDLE: ctr <= 5'd0;
                RUN:  if (ctr < 5'd16) ctr <= ctr + 1'b1;
                      else ctr <= ctr; // Hold at 16
                default: ctr <= 5'd0;
            endcase
        end
    end

    // Registers and product update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p <= 16'd0;
            rdy <= 1'b0;
            multiplicand_shifted <= { {8{a[7]}}, a };
            multiplier_ext <= { {8{b[7]}}, b };
        end else begin
            case (state)
                IDLE: begin
                    p <= 16'd0;
                    rdy <= 1'b0;
                    multiplicand_shifted <= { {8{a[7]}}, a };
                    multiplier_ext <= { {8{b[7]}}, b };
                end
                RUN: begin
                    if (ctr < 5'd16) begin
                        if (multiplier_ext[ctr] == 1'b1)
                            p <= p + multiplicand_shifted;
                        else
                            p <= p;
                        multiplicand_shifted <= multiplicand_shifted <<< 1;
                        rdy <= 1'b0;
                    end else begin
                        // multiplication finished
                        rdy <= 1'b1;
                        p <= p;
                        multiplicand_shifted <= multiplicand_shifted;
                    end
                end
                default: begin
                    p <= 16'd0;
                    rdy <= 1'b0;
                    multiplicand_shifted <= 16'sd0;
                    multiplier_ext <= 16'd0;
                end
            endcase
        end
    end

endmodule