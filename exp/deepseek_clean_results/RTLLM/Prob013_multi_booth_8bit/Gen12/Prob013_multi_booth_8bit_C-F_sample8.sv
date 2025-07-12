module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] mcand;        // Optimized 10-bit multiplicand
    reg [7:0] mplier;       // Multiplier
    reg [1:0] counter;      // 2-bit counter (one-hot encoded)
    reg prev_bit;           // Previous bit for Booth encoding
    reg [15:0] p_next;      // Pipeline register for product
    reg shift_en;           // Clock gating for shift operations

    // One-hot encoded counter states
    parameter IDLE = 2'b00, ITER1 = 2'b01, ITER2 = 2'b10, ITER3 = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {a[7], a[7], a};  // Sign extended to 10 bits
            mplier <= b;
            p <= 16'b0;
            p_next <= 16'b0;
            counter <= IDLE;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
            shift_en <= 1'b0;
        end else begin
            if (!rdy) begin
                // Arithmetic operations (pipelined)
                case ({mplier[1:0], prev_bit})
                    3'b000, 3'b111: p_next <= p;                 // +0
                    3'b001, 3'b010: p_next <= p + {{6{mcand[9]}}, mcand};  // +1
                    3'b011: p_next <= p + {{5{mcand[9]}}, mcand, 1'b0};    // +2
                    3'b100: p_next <= p - {{5{mcand[9]}}, mcand, 1'b0};    // -2
                    3'b101, 3'b110: p_next <= p - {{6{mcand[9]}}, mcand};  // -1
                endcase

                // Update product register
                p <= p_next;

                // Controlled shifting operations
                if (shift_en) begin
                    mcand <= mcand << 2;
                    mplier <= mplier >> 2;
                    prev_bit <= mplier[1];
                end

                // State transition
                case (counter)
                    IDLE: begin
                        counter <= ITER1;
                        shift_en <= 1'b1;
                    end
                    ITER1: counter <= ITER2;
                    ITER2: counter <= ITER3;
                    ITER3: begin
                        counter <= IDLE;
                        rdy <= 1'b1;
                        shift_en <= 1'b0;
                    end
                endcase
            end
        end
    end

endmodule