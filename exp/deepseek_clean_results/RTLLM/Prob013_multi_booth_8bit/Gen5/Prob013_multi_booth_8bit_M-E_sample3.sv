module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    typedef enum logic [1:0] {
        STAGE_IDLE,
        STAGE_ENCODE,
        STAGE_SELECT,
        STAGE_ADD,
        STAGE_FINAL
    } stage_t;

    // Pipeline registers
    reg [1:0] stage, next_stage;
    reg [2:0] cycle_count;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] partial_products [0:3];
    reg [15:0] sum [0:1];
    reg [15:0] carry [0:1];
    reg [3:0] booth_sel [0:3];

    // Precompute all possible partial products
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = {multiplicand[14:0], 1'b0};
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -{multiplicand[14:0], 1'b0};

    // Booth encoder (combinational)
    function [3:0] booth_encoder;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_encoder = 4'b0000; // 0
                3'b001, 3'b010: booth_encoder = 4'b0001; // +A
                3'b011:         booth_encoder = 4'b0010; // +2A
                3'b100:         booth_encoder = 4'b1100; // -2A
                3'b101, 3'b110: booth_encoder = 4'b1011; // -A
                default:        booth_encoder = 4'b0000;
            endcase
        end
    endfunction

    // Main pipeline control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= STAGE_IDLE;
            cycle_count <= 0;
            rdy <= 1'b0;
            p <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= 16'b0;
        end else begin
            stage <= next_stage;
            
            case (stage)
                STAGE_IDLE: begin
                    if (!reset) begin
                        multiplicand <= {{8{a[7]}}, a};
                        multiplier <= {{8{b[7]}}, b};
                        cycle_count <= 0;
                        rdy <= 1'b0;
                    end
                end
                
                STAGE_ENCODE: begin
                    // Generate all booth selections in parallel
                    booth_sel[0] <= booth_encoder({multiplier[1:0], 1'b0});
                    booth_sel[1] <= booth_encoder(multiplier[3:1]);
                    booth_sel[2] <= booth_encoder(multiplier[5:3]);
                    booth_sel[3] <= booth_encoder(multiplier[7:5]);
                    cycle_count <= cycle_count + 1;
                end
                
                STAGE_SELECT: begin
                    // Select partial products based on booth encoding
                    for (int i = 0; i < 4; i = i + 1) begin
                        case (booth_sel[i][3:0])
                            4'b0000: partial_products[i] <= pp_0;
                            4'b0001: partial_products[i] <= pp_A << (i*2);
                            4'b0010: partial_products[i] <= pp_2A << (i*2);
                            4'b1011: partial_products[i] <= pp_negA << (i*2);
                            4'b1100: partial_products[i] <= pp_neg2A << (i*2);
                            default: partial_products[i] <= pp_0;
                        endcase
                    end
                    cycle_count <= cycle_count + 1;
                end
                
                STAGE_ADD: begin
                    // Carry-save addition tree (first level)
                    {carry[0], sum[0]} = partial_products[0] + partial_products[1];
                    {carry[1], sum[1]} = partial_products[2] + partial_products[3];
                    cycle_count <= cycle_count + 1;
                end
                
                STAGE_FINAL: begin
                    // Final addition and output
                    p <= sum[0] + sum[1] + (carry[0] << 1) + (carry[1] << 1);
                    rdy <= 1'b1;
                    cycle_count <= 0;
                end
            endcase
        end
    end

    // Next stage logic
    always @* begin
        case (stage)
            STAGE_IDLE:   next_stage = STAGE_ENCODE;
            STAGE_ENCODE: next_stage = STAGE_SELECT;
            STAGE_SELECT: next_stage = STAGE_ADD;
            STAGE_ADD:    next_stage = STAGE_FINAL;
            STAGE_FINAL:  next_stage = STAGE_IDLE;
            default:      next_stage = STAGE_IDLE;
        endcase
    end

endmodule