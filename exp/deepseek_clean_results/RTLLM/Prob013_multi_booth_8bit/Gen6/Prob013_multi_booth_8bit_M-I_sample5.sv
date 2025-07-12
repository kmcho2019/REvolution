module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;
    reg [15:0] accumulator;
    reg [1:0] prev_bit;

    // Sign-extended operands
    wire [15:0] a_ext = {{8{a[7]}}, a};
    wire [15:0] b_ext = {{8{b[7]}}, b};

    // Booth encoding
    wire [1:0] booth_bits = multiplier[1:0];
    wire [15:0] booth_mux;

    // Booth multiplexer
    always @(*) begin
        case (booth_bits)
            2'b00: booth_mux = 16'b0;            // 0
            2'b01: booth_mux = multiplicand;     // +1
            2'b10: booth_mux = multiplicand << 1; // +2
            2'b11: booth_mux = ~(multiplicand << 1) + 1; // -2
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= a_ext;
            multiplier <= b_ext;
            accumulator <= 16'b0;
            ctr <= 5'b0;
            prev_bit <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (ctr < 8) begin
                // Accumulate partial product
                accumulator <= accumulator + booth_mux;

                // Arithmetic right shift multiplier
                multiplier <= {multiplier[15], multiplier[15:1]};

                // Left shift multiplicand
                multiplicand <= multiplicand << 2;

                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                p <= accumulator;
                rdy <= 1'b1;
            end
        end
    end

endmodule