module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,       // multiplier input
    input      [7:0] b,       // multiplicand input
    output reg [15:0] p,      // product output
    output reg       rdy       // ready signal
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        RUN  = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers for signed arithmetic
    reg signed [15:0] multiplier;     // sign-extended multiplier
    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg signed [15:0] product;        // accumulated product
    reg [4:0] ctr;                    // counter from 0 to 16

    // Control signal: whether to add multiplicand this cycle (multiplier bit)
    wire add_en = multiplier[ctr];

    // State machine: sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= LOAD;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            LOAD: next_state = RUN;
            RUN:  next_state = (ctr == 5'd16) ? IDLE : RUN;
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath operations on clock edge
    always @(posedge clk) begin
        if (reset) begin
            // Load sign-extended inputs
            multiplier   <= { {8{a[7]}}, a };
            multiplicand <= { {8{b[7]}}, b };
            product      <= 16'sd0;
            ctr          <= 5'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            case (state)
                LOAD: begin
                    // Initialize registers on load state
                    multiplier   <= { {8{a[7]}}, a };
                    multiplicand <= { {8{b[7]}}, b };
                    product      <= 16'sd0;
                    ctr          <= 5'd0;
                    rdy          <= 1'b0;
                end

                RUN: begin
                    if (ctr < 5'd16) begin
                        // Add multiplicand to product if multiplier bit at ctr is 1
                        if (add_en)
                            product <= product + multiplicand;
                        else
                            product <= product;
                        // Shift multiplicand left by 1 for next cycle
                        multiplicand <= multiplicand <<< 1;

                        ctr <= ctr + 1'b1;

                        rdy <= 1'b0;
                        p <= p; // hold previous output
                    end else begin
                        // Done multiplying
                        p <= product;
                        rdy <= 1'b1;
                        // hold registers steady
                        multiplicand <= multiplicand;
                        product <= product;
                        multiplier <= multiplier;
                        ctr <= ctr;
                    end
                end

                IDLE: begin
                    // Maintain outputs and registers stable
                    rdy <= rdy;
                    p <= p;
                    multiplier <= multiplier;
                    multiplicand <= multiplicand;
                    product <= product;
                    ctr <= ctr;
                end

                default: begin
                    // Default safe assignments
                    rdy <= 1'b0;
                    p <= 16'd0;
                    multiplier <= {16{1'b0}};
                    multiplicand <= {16{1'b0}};
                    product <= 16'sd0;
                    ctr <= 5'd0;
                end
            endcase
        end
    end

endmodule