module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] mcand;        // Multiplicand (sign extended)
    reg [15:0] mcand_x2;     // Precomputed mcand*2
    reg [8:0] mplier;        // Multiplier with extra bit for shifting
    reg [1:0] counter;       // 2-bit counter
    reg [2:0] booth_bits;    // Registered booth encoding bits
    reg [15:0] partial_prod; // Selected partial product
    reg compute_en;          // Computation enable

    // Precompute mcand*2 for faster operation
    wire [15:0] next_mcand = mcand << 1;
    wire [15:0] next_mcand_x2 = mcand_x2 << 2;

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {{8{a[7]}}, a};
            mcand_x2 <= {{8{a[7]}}, a} << 1;
            mplier <= {b, 1'b0};  // Initialize with extra 0 for first iteration
            p <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            compute_en <= 1'b1;
        end else if (!rdy) begin
            // Stage 1: Booth encoding and partial product selection
            booth_bits <= {mplier[2:0]};
            
            case (mplier[2:0])
                3'b000, 3'b111: partial_prod <= 16'b0;
                3'b001, 3'b010: partial_prod <= mcand;
                3'b011:         partial_prod <= mcand_x2;
                3'b100:         partial_prod <= -mcand_x2;
                3'b101, 3'b110: partial_prod <= -mcand;
            endcase

            // Stage 2: Accumulation and shifting
            if (compute_en) begin
                p <= p + partial_prod;
                mcand <= next_mcand_x2;
                mcand_x2 <= next_mcand_x2 << 1;
                mplier <= mplier >> 2;
                counter <= counter + 1;
                rdy <= (counter == 2'b11);
            end
            
            // Clock gating logic
            compute_en <= !(counter == 2'b11);
        end
    end

endmodule