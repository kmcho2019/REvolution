module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [2:0] counter;
    reg prev_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign-extended values
            multiplicand <= {{8{a[7]}}, a};
            p <= {8'b0, b};
            counter <= 3'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end
        else if (!rdy) begin
            // Booth Radix-4 encoding (3 bits)
            case ({p[1:0], prev_bit})
                3'b000, 3'b111: ; // No operation
                3'b001, 3'b010: p <= p + {multiplicand[13:0], 2'b0};
                3'b011: p <= p + {multiplicand[12:0], 3'b0};
                3'b100: p <= p - {multiplicand[12:0], 3'b0};
                3'b101, 3'b110: p <= p - {multiplicand[13:0], 2'b0};
            endcase

            // Arithmetic right shift by 2 (Radix-4)
            p <= {p[15], p[15], p[15:2]};
            prev_bit <= p[1];
            counter <= counter + 1;

            // Check completion (4 iterations for 8-bit)
            if (counter == 3'b100) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule