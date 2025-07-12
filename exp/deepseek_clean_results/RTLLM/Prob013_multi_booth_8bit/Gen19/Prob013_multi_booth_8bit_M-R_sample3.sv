module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    // Internal registers
    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [1:0] state;
    reg [2:0] counter;

    // Pre-compute possible arithmetic operations
    wire [15:0] add_multiplicand = p + multiplicand;
    wire [15:0] sub_multiplicand = p - multiplicand;
    wire [15:0] add_2multiplicand = p + (multiplicand << 1);
    wire [15:0] sub_2multiplicand = p - (multiplicand << 1);

    // Booth encoding
    wire [2:0] booth_bits = {multiplier[1:0], prev_lsb};

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end
                
                CALC: begin
                    if (counter < 4) begin
                        // Perform Booth operation
                        case (booth_bits)
                            3'b001, 3'b010: p <= add_multiplicand;
                            3'b011:         p <= add_2multiplicand;
                            3'b100:         p <= sub_2multiplicand;
                            3'b101, 3'b110: p <= sub_multiplicand;
                            default:        p <= p; // 000,111
                        endcase

                        // Update registers
                        multiplicand <= multiplicand << 2;
                        prev_lsb <= multiplier[1];
                        multiplier <= multiplier >> 2;
                        counter <= counter + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE; // Ready for next operation
                end
            endcase
        end
    end

endmodule