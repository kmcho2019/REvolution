module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand input
    input      [7:0]  b,      // multiplier input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    reg signed [15:0] multiplier;    // sign-extended multiplier
    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg signed [15:0] product;       // accumulated product

    reg [4:0] ctr;

    wire multiplier_bit = multiplier[ctr];

    // State and datapath sequential logic with asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize multiplier and multiplicand by sign-extension,
            // clear product and counter, clear ready flag, and set to IDLE state
            multiplier   <= {{8{b[7]}}, b};  // multiplier is 'b' according to user spec
            multiplicand <= {{8{a[7]}}, a};  // multiplicand is 'a' according to user spec
            product      <= 16'sd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            state        <= IDLE;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    // Prepare for multiplication on IDLE state, clear product and counter
                    product <= 16'sd0;
                    ctr     <= 5'd0;
                    rdy     <= 1'b0;
                    // multiplier and multiplicand remain constant from reset
                end
                RUN: begin
                    // Accumulate if multiplier bit is 1
                    if (multiplier_bit)
                        product <= product + multiplicand;
                    // Shift multiplicand left by 1 (equivalent to multiplicand * 2)
                    multiplicand <= multiplicand <<< 1;
                    ctr <= ctr + 1;
                end
                DONE: begin
                    // Multiplication done, output product and set ready signal
                    p   <= product;
                    rdy <= 1'b1;
                    // Hold product and rdy stable until reset
                end
                default: begin
                    // Safe fallback
                    product <= 16'sd0;
                    ctr     <= 5'd0;
                    rdy     <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:  next_state = RUN;
            RUN:   next_state = (ctr == 5'd16) ? DONE : RUN;
            DONE:  next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule