module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // Extra bit for Booth encoding
    reg [4:0] ctr;
    
    // Pre-computed partial products
    wire [15:0] pp_a = multiplicand;
    wire [15:0] pp_2a = multiplicand << 1;
    wire [15:0] pp_neg_a = -multiplicand;
    wire [15:0] pp_neg_2a = -(multiplicand << 1);
    
    // Pipeline registers
    reg [15:0] partial_product;
    reg [15:0] accum;
    reg [16:0] next_multiplier;
    
    // Booth encoding
    wire [2:0] booth_bits = multiplier[2:0];
    
    // Partial product selection
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 16'b0;
            3'b001, 3'b010: partial_product = pp_a;
            3'b011:         partial_product = pp_2a;
            3'b100:         partial_product = pp_neg_2a;
            3'b101, 3'b110: partial_product = pp_neg_a;
            default:        partial_product = 16'b0;
        endcase
    end
    
    // State machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b, 1'b0};
            p <= 16'b0;
            rdy <= 1'b0;
            ctr <= 5'b0;
            accum <= 16'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (!reset) begin
                        next_multiplier <= {{8{b[7]}}, b, 1'b0};
                        accum <= 16'b0;
                        ctr <= 5'b0;
                    end
                end
                
                COMPUTE: begin
                    // Pipeline stage 1: Partial product generation (combinational)
                    
                    // Pipeline stage 2: Accumulation and shifting
                    accum <= accum + partial_product;
                    multiplier <= $signed(multiplier) >>> 2;
                    multiplicand <= multiplicand << 2;
                    ctr <= ctr + 1;
                end
                
                DONE: begin
                    p <= accum;
                    rdy <= 1'b1;
                end
            endcase
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = COMPUTE;
            COMPUTE: next_state = (ctr == 5'd3) ? DONE : COMPUTE;
            DONE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Output logic
    always @(*) begin
        rdy = (state == DONE);
    end

endmodule