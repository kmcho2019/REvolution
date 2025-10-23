module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] mcand;        // Reduced to 10 bits (8 + 2 max shift)
    reg [7:0] mplier;
    reg [1:0] counter;
    reg prev_bit;
    reg [15:0] p_temp;      // Pipeline register
    reg [15:0] pp_result;   // Partial product result
    wire clk_gated;

    // Clock gating for shift operations
    assign clk_gated = clk & ~rdy;

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {a[7], a[7], a};  // Sign extend to 10 bits
            mplier <= b;
            p <= 16'b0;
            p_temp <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end
    end

    always @(posedge clk_gated) begin
        // Stage 1: Booth encoding and partial product calculation
        case ({mplier[1:0], prev_bit})
            3'b000, 3'b111: pp_result <= 16'b0;
            3'b001, 3'b010: pp_result <= {{6{mcand[9]}}, mcand};
            3'b011: pp_result <= {{5{mcand[9]}}, mcand, 1'b0};
            3'b100: pp_result <= -{{5{mcand[9]}}, mcand, 1'b0};
            3'b101, 3'b110: pp_result <= -{{6{mcand[9]}}, mcand};
        endcase

        // Stage 2: Accumulate partial product
        p_temp <= p + pp_result;

        // Update registers
        mcand <= mcand << 2;
        mplier <= mplier >> 2;
        prev_bit <= mplier[1];
        counter <= counter + 1;
        p <= p_temp;
        rdy <= (counter == 2'b11);
    end

endmodule