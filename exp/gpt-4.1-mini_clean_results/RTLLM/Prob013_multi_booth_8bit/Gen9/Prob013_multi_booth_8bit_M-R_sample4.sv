module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready signal
);

    // State machine states
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state, next_state;

    // Sign-extended inputs
    reg signed [15:0] multiplicand;
    reg [8:0] multiplier_ext; // 8-bit multiplier + appended zero at LSB

    // 5-bit counter for iterations (only 4 iterations used for radix-4 8-bit)
    reg [2:0] iteration;

    // Accumulator for partial product, signed 32-bit to handle overflow
    reg signed [31:0] product_accum;

    // Booth code extraction wires
    wire [2:0] booth_code;

    // Function to decode radix-4 Booth 3-bit code into multiplier factor (-2 to 2)
    function signed [2:0] booth_decode;
        input [2:0] code;
        begin
            case(code)
                3'b000, 3'b111: booth_decode =  3'sd0;
                3'b001, 3'b010: booth_decode =  3'sd1;
                3'b011:         booth_decode =  3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode =  3'sd0;
            endcase
        end
    endfunction

    // Assign the booth_code combinationally: bits at positions [2*iteration+1:2*iteration-1] of multiplier_ext
    // Handle bit underflow by treating out-of-range bits as 0
    wire bit_minus1, bit0, bit1;
    wire [3:0] bit_pos = iteration * 2;

    assign bit_minus1 = (bit_pos == 0) ? 1'b0 : multiplier_ext[bit_pos - 1];
    assign bit0       = multiplier_ext[bit_pos];
    assign bit1       = (bit_pos + 1 < 9) ? multiplier_ext[bit_pos + 1] : 1'b0;

    assign booth_code = {bit1, bit0, bit_minus1};

    // Partial product calculation based on Booth decode factor
    wire signed [2:0] factor;
    assign factor = booth_decode(booth_code);

    wire signed [31:0] multiplicand_32;
    assign multiplicand_32 = {{16{multiplicand[15]}}, multiplicand};

    wire signed [31:0] partial_product_pre_shift;
    assign partial_product_pre_shift = (factor == 3'sd0) ? 32'sd0 :
                                      (factor == 3'sd1) ? multiplicand_32 :
                                      (factor == 3'sd2) ? (multiplicand_32 <<< 1) :
                                      (factor == -3'sd1) ? (-multiplicand_32) :
                                      (factor == -3'sd2) ? (-(multiplicand_32 <<< 1)) :
                                      32'sd0;

    wire signed [31:0] partial_product;
    assign partial_product = partial_product_pre_shift <<< (iteration * 2);

    // State machine and datapath sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= IDLE;
            multiplicand  <= 16'sd0;
            multiplier_ext <= 9'd0;
            iteration     <= 3'd0;
            product_accum <= 32'sd0;
            p             <= 16'd0;
            rdy           <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    iteration <= 3'd0;
                    product_accum <= 32'sd0;
                    // Load sign-extended multiplicand and multiplier (multiplier plus appended zero LSB)
                    multiplicand <= { {8{a[7]}}, a };
                    multiplier_ext <= {b, 1'b0};
                end
                RUNNING: begin
                    product_accum <= product_accum + partial_product;
                    iteration <= iteration + 3'd1;
                end
                DONE: begin
                    p   <= product_accum[15:0]; // output lower 16 bits as product
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = RUNNING;
            RUNNING: next_state = (iteration == 3'd3) ? DONE : RUNNING; // 4 iterations: 0..3
            DONE:    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule