module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [9:0] mcand;         // Multiplicand (optimized width)
    reg [7:0] mplier;        // Multiplier
    reg [3:0] state;         // One-hot encoded state (4 states)
    reg prev_bit;            // Previous bit for Booth encoding
    reg [15:0] partial_sum;  // Pipelined partial sum

    // Pre-compute shifted values
    wire [15:0] mcand_x1 = {{6{mcand[9]}}, mcand};
    wire [15:0] mcand_x2 = {{5{mcand[9]}}, mcand, 1'b0};

    always @(posedge clk) begin
        if (reset) begin
            mcand <= {a[7], a[7], a};    // Sign extended to 10 bits
            mplier <= b;
            p <= 16'b0;
            state <= 4'b0001;            // One-hot initialization
            prev_bit <= 1'b0;
            rdy <= 1'b0;
            partial_sum <= 16'b0;
        end else if (!rdy) begin
            // Stage 1: Booth encoding and partial sum calculation
            case ({mplier[1:0], prev_bit})
                3'b000, 3'b111: partial_sum <= p;
                3'b001, 3'b010: partial_sum <= p + mcand_x1;
                3'b011: partial_sum <= p + mcand_x2;
                3'b100: partial_sum <= p - mcand_x2;
                3'b101, 3'b110: partial_sum <= p - mcand_x1;
            endcase

            // Stage 2: Update registers and shift
            p <= partial_sum;
            mcand <= {mcand[7:0], 2'b0}; // Shift left by 2
            mplier <= {2'b0, mplier[7:2]}; // Shift right by 2
            prev_bit <= mplier[1];
            
            // State transition
            state <= {state[2:0], state[3]};
            rdy <= state[3];
        end
    end

endmodule