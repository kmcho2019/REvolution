module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] cycle;        // 0-7 cycle counter
    reg [15:0] multiplicand;
    reg [31:0] product;
    reg [31:0] sum;
    reg [31:0] carry;
    reg running;
    wire [2:0] booth_bits;
    wire [31:0] pp_0, pp_1, pp_2;
    wire [31:0] next_sum, next_carry;

    // Booth encoding (unsigned radix-4)
    assign booth_bits = (cycle == 0) ? {1'b0, multiplicand[1:0]} :
                       {multiplicand[cycle*2+1], multiplicand[cycle*2:cycle*2-1]};

    // Pre-computed partial products
    assign pp_0 = 32'd0;
    assign pp_1 = {16'd0, bin};
    assign pp_2 = {15'd0, bin, 1'b0};

    // Partial product selection
    wire [31:0] selected_pp = (booth_bits == 3'b000) ? pp_0 :
                             (booth_bits == 3'b001) ? pp_1 :
                             (booth_bits == 3'b010) ? pp_1 :
                             (booth_bits == 3'b011) ? pp_2 :
                             pp_0;

    // Shift amount calculation
    wire [31:0] shifted_pp = selected_pp << (cycle*2);

    // Carry-save adder
    assign next_sum = sum ^ carry ^ shifted_pp;
    assign next_carry = (sum & carry) | (sum & shifted_pp) | (carry & shifted_pp);

    // Early termination detection
    wire remaining_zero = (multiplicand >> (cycle*2+2)) == 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle <= 4'd0;
            multiplicand <= 16'd0;
            product <= 32'd0;
            sum <= 32'd0;
            carry <= 32'd0;
            running <= 1'b0;
            done <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize on start
                multiplicand <= ain;
                sum <= 32'd0;
                carry <= 32'd0;
                cycle <= 4'd0;
                running <= 1'b1;
                done <= 1'b0;
            end else if (running) begin
                if (remaining_zero) begin
                    // Early termination
                    product <= sum + carry;
                    running <= 1'b0;
                    done <= 1'b1;
                    cycle <= 4'd0;
                end else if (cycle == 4'd7) begin
                    // Final cycle
                    product <= sum + carry + shifted_pp;
                    running <= 1'b0;
                    done <= 1'b1;
                    cycle <= 4'd0;
                end else begin
                    // Normal operation
                    sum <= next_sum;
                    carry <= next_carry << 1;
                    cycle <= cycle + 1;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        yout = product;
    end

endmodule