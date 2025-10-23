module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] multiplicand;  // 8 + 2 bits for shifting
    reg [3:0] mult_ctr;      // [2:1] multiplier bits, [0] counter
    reg [1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= {a[7], a[7], a};  // Sign extend 2 bits
            mult_ctr <= {b[1:0], 2'b0};       // Initialize multiplier bits
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Booth encoding (using mult_ctr[2:0] as {current, prev})
            case (mult_ctr[2:0])
                3'b000, 3'b111: ;  // No operation
                3'b001, 3'b010: p <= p + multiplicand[9:0];
                3'b011:         p <= p + {multiplicand[8:0], 1'b0};
                3'b100:         p <= p - {multiplicand[8:0], 1'b0};
                3'b101, 3'b110: p <= p - multiplicand[9:0];
            endcase

            // Update registers
            multiplicand <= multiplicand << 2;
            mult_ctr <= {b[2*counter+3], b[2*counter+2], counter + 1};

            // Completion detection
            rdy <= (counter == 2'b11);
            counter <= counter + 1;
        end
    end

endmodule