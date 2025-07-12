module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,       // multiplicand
    input  wire [7:0]  b,       // multiplier
    output reg  [15:0] p,       // product output (lower 16 bits)
    output reg         rdy       // ready signal
);

    // FSM states encoding as localparams for Verilog compatibility
    localparam IDLE = 2'b00,
               CALC = 2'b01,
               DONE = 2'b10;

    reg [1:0] state, next_state;

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg [15:0]        multiplier;      // sign-extended multiplier
    reg signed [31:0] product_accum;   // 32-bit accumulator for intermediate product
    reg [4:0]         ctr;             // 5-bit cycle counter (0 to 16)

    // Combinational shifted multiplicand for current bit position
    wire signed [31:0] shifted_multiplicand = multiplicand <<< ctr;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            IDLE:   next_state = (reset) ? IDLE : CALC;
            CALC:   next_state = (ctr == 5'd16) ? DONE : CALC;
            DONE:   next_state = IDLE;  // After done, wait for reset to start new operation
            default: next_state = IDLE;
        endcase
    end

    // Sequential FSM and datapath
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Load sign-extended inputs and reset control registers
            multiplicand  <= {{8{a[7]}}, a};
            multiplier    <= {{8{b[7]}}, b};
            product_accum <= 32'sd0;
            ctr           <= 5'd0;
            p             <= 16'd0;
            rdy           <= 1'b0;
            state         <= IDLE;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    // Wait for reset to end to start calculation
                    // Clear outputs and counters in IDLE for safe start
                    product_accum <= 32'sd0;
                    ctr           <= 5'd0;
                    p             <= 16'd0;
                    rdy           <= 1'b0;
                end

                CALC: begin
                    // If multiplier bit at ctr is 1, add shifted multiplicand to product_accum
                    if (multiplier[ctr])
                        product_accum <= product_accum + shifted_multiplicand;

                    ctr <= ctr + 1;
                end

                DONE: begin
                    p   <= product_accum[15:0]; // output lower 16 bits
                    rdy <= 1'b1;                // signal ready
                end

                default: ; // do nothing
            endcase
        end
    end

endmodule