module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input
    input      [7:0]  b,        // multiplier input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // States for FSM
    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg signed [15:0] multiplier_ext; // sign-extended multiplier with appended zero bit for booth recoding
    reg signed [31:0] product_acc;    // accumulator wider to hold shifted partial sums

    reg [1:0] count;                  // counts 0 to 3 for 4 cycles (2 bits)
    reg [2:0] booth_bits;             // current 3-bit booth encoding bits
    reg signed [15:0] pp;             // partial product for current iteration

    // Function to decode radix-4 Booth bits and produce partial product factor * multiplicand
    // Booth encoding rules for 3 bits (y2 y1 y0):
    // 000 ->  0
    // 001 -> +1 * M
    // 010 -> +1 * M
    // 011 -> +2 * M
    // 100 -> -2 * M
    // 101 -> -1 * M
    // 110 -> -1 * M
    // 111 ->  0
    function signed [15:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] M;
        begin
            case (bits)
                3'b000,
                3'b111: booth_decode = 16'sd0;
                3'b001,
                3'b010: booth_decode = M;
                3'b011: booth_decode = M <<< 1;        // *2
                3'b100: booth_decode = -(M <<< 1);    // *-2
                3'b101,
                3'b110: booth_decode = -M;
                default: booth_decode = 16'sd0;
            endcase
        end
    endfunction

    // Prepare extended multiplier with appended zero bit at LSB for Booth recoding
    wire [8:0] multiplier_with_zero = {b[7], b, 1'b0};

    always @(posedge clk) begin
        if (reset) begin
            // Initialize on reset
            multiplicand   <= {{8{a[7]}}, a};
            multiplier_ext <= {multiplier_with_zero};  // 9-bit extended multiplier, sign-extended to 16 bits
            product_acc    <= 32'sd0;
            count          <= 2'd0;
            p              <= 16'd0;
            rdy            <= 1'b0;
            state          <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    product_acc <= 32'sd0;
                    count <= 2'd0;
                    multiplicand <= {{8{a[7]}}, a};       // re-load inputs in case they changed
                    multiplier_ext <= {multiplier_with_zero}; // re-load multiplier with appended zero
                    p <= 16'd0;
                    state <= CALC;
                end

                CALC: begin
                    // Extract 3 bits for Booth recoding at positions 2*count+1 downto 2*count-1
                    // Note: For count=0, bits = multiplier_ext[1: -1] but -1 invalid so LSB appended zero bit used
                    // Using multiplier_with_zero which has 9 bits: bits from [2*count+1 : 2*count-1]
                    // Because multiplier_ext is sign extended to 16 bits, extract from multiplier_with_zero for correct 3 bits
                    booth_bits <= multiplier_with_zero[2*count + 1 -: 3]; 

                    // Compute partial product
                    pp <= booth_decode(booth_bits, multiplicand);

                    // Add shifted partial product to accumulator
                    // Shift by 2*count bits to the left
                    product_acc <= product_acc + ({{16{pp[15]}}, pp} <<< (2*count));

                    if (count == 2'd3) begin
                        // Done after 4 iterations
                        p <= product_acc[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end else begin
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    // Hold ready until reset
                    rdy <= 1'b1;
                    // Optionally stay in DONE until reset or inputs change
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule