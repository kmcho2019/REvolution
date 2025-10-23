module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier_ext;
    reg [15:0] partial_product;
    reg [3:0] shift_amount;
    reg [1:0] booth_code;
    reg [4:0] ctr;
    reg processing;

    // Booth encoding constants
    localparam ADD_1X  = 2'b01;
    localparam ADD_2X  = 2'b10;
    localparam SUB_1X  = 2'b11;
    localparam SUB_2X  = 2'b00;

    // Early termination flags
    wire all_zeros = (multiplier_ext == 16'b0);
    wire all_ones  = (&multiplier_ext);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand   <= {{8{a[7]}}, a};
            multiplier_ext <= {{8{b[7]}}, b, 1'b0}; // Extra bit for Booth
            partial_product <= 16'b0;
            p              <= 16'b0;
            rdy            <= 1'b0;
            ctr            <= 5'b0;
            processing     <= 1'b0;
        end else begin
            if (!processing && !rdy) begin
                // Start processing
                processing <= 1'b1;
                ctr <= 5'b0;
            end else if (processing) begin
                // Pipeline Stage 1: Booth Encoding
                booth_code <= multiplier_ext[1:0];
                shift_amount <= ctr[3:0] << 1; // Radix-4 (2 bits per cycle)

                // Pipeline Stage 2: Accumulation
                case (booth_code)
                    ADD_1X:  partial_product <= partial_product + (multiplicand << shift_amount);
                    ADD_2X:  partial_product <= partial_product + (multiplicand << (shift_amount + 1));
                    SUB_1X:  partial_product <= partial_product - (multiplicand << shift_amount);
                    SUB_2X:  partial_product <= partial_product - (multiplicand << (shift_amount + 1));
                    default: partial_product <= partial_product;
                endcase

                // Shift multiplier for next cycle
                multiplier_ext <= multiplier_ext >>> 2;

                // Update counter and check completion
                ctr <= ctr + 1;
                if (ctr == 5'b01000 || all_zeros || all_ones) begin // 8 bits / 2 = 4 cycles
                    p <= partial_product;
                    rdy <= 1'b1;
                    processing <= 1'b0;
                end
            end else begin
                rdy <= 1'b0; // Clear ready for next operation
            end
        end
    end

endmodule