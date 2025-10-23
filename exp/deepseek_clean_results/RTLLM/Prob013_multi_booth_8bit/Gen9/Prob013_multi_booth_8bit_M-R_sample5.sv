module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

    // State definitions
    localparam IDLE  = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // 16-bit + previous LSB
    reg [15:0] product_reg;
    reg [2:0] cycle_count;

    // Output assignments
    assign p = product_reg;
    assign rdy = (state == DONE);

    // Product update calculations
    wire [15:0] product_plus_mc = product_reg + multiplicand;
    wire [15:0] product_minus_mc = product_reg - multiplicand;
    wire [15:0] product_plus_2mc = product_reg + (multiplicand << 1);
    wire [15:0] product_minus_2mc = product_reg - (multiplicand << 1);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};
            product_reg <= 16'b0;
            cycle_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= COMPUTE;
                    cycle_count <= 3'b0;
                end

                COMPUTE: begin
                    // Radix-4 Booth encoding
                    case (multiplier[2:0])
                        3'b000, 3'b111: product_reg <= product_reg;
                        3'b001, 3'b010: product_reg <= product_plus_mc;
                        3'b011:         product_reg <= product_plus_2mc;
                        3'b100:         product_reg <= product_minus_2mc;
                        3'b101, 3'b110: product_reg <= product_minus_mc;
                    endcase

                    // Arithmetic right shift by 2 bits
                    multiplier <= {multiplier[16], multiplier[16], multiplier[16:2]};

                    // Update cycle count
                    cycle_count <= cycle_count + 1;

                    // Transition to DONE after 4 cycles (8 bits / 2 bits per cycle)
                    if (cycle_count == 3) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold in done state until reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule