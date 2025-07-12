module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready flag
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;
    reg [1:0] state;

    reg signed [15:0] multiplicand;
    reg signed [17:0] product;      // 18 bits to hold intermediate product with shift room
    reg [9:0]         mplier_ext;   // multiplier extended with appended 0 LSB for Booth groups
    reg [2:0]         step;         // counts from 0 to 3 for 4 steps (8 bits / 2 bits)

    // Booth decoding function
    function signed [2:0] booth_op;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_op = 3'd0;
                3'b001, 3'b010: booth_op = 3'd1;
                3'b011:         booth_op = 3'd2;
                3'b100:         booth_op = -3'd2;
                3'b101, 3'b110: booth_op = -3'd1;
                default:        booth_op = 3'd0;
            endcase
        end
    endfunction

    reg signed [15:0] addend;
    wire [2:0] curr_bits = mplier_ext[2:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            mplier_ext   <= {b, 1'b0}; // append 0 LSB for Booth
            product      <= 18'd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
            state        <= CALC;
        end else begin
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    product <= 18'd0;
                    mplier_ext <= {b, 1'b0};
                    multiplicand <= {{8{a[7]}}, a};
                    step <= 3'd0;
                    state <= CALC;
                end

                CALC: begin
                    // Decode booth_op for current 3 bits
                    case (booth_op(curr_bits))
                        3'd0:  addend = 16'sd0;
                        3'd1:  addend = multiplicand;
                        3'd2:  addend = multiplicand <<< 1;
                        -3'd1: addend = -multiplicand;
                        -3'd2: addend = -(multiplicand <<< 1);
                        default: addend = 16'sd0;
                    endcase

                    // Accumulate shifted addend into product
                    // Shift by step*2 bits to align partial product
                    product <= product + ({{2{addend[15]}}, addend} <<< (step * 2));

                    // Shift multiplier right by 2 bits for next step
                    mplier_ext <= mplier_ext >> 2;

                    // Increment step counter or finish
                    if (step == 3'd3) begin
                        p <= product[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end else begin
                        step <= step + 1;
                    end
                end

                DONE: begin
                    // Hold result until reset; could add handshake or start input if needed
                    rdy <= 1'b1;
                    // Remain in DONE until reset
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule