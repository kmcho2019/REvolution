module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] iteration;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_lsb;

    // Pre-compute all possible shifted multiplicand values
    wire [15:0] m_shift0 = multiplicand;
    wire [15:0] m_shift1 = multiplicand << 1;
    wire [15:0] m_shift2 = multiplicand << 2;
    wire [15:0] m_shift3 = multiplicand << 3;
    wire [15:0] m_shift4 = multiplicand << 4;
    wire [15:0] m_shift5 = multiplicand << 5;
    wire [15:0] m_shift6 = multiplicand << 6;

    // Booth encoding selection
    wire [2:0] booth_enc = {multiplier[1:0], prev_lsb};
    wire [15:0] partial_product;

    // Booth encoding case logic using continuous assignment
    assign partial_product = 
        (booth_enc == 3'b000 || booth_enc == 3'b111) ? 16'b0 :
        (booth_enc == 3'b001 || booth_enc == 3'b010) ? m_shift0 :
        (booth_enc == 3'b011) ? m_shift1 :
        (booth_enc == 3'b100) ? -m_shift1 :
        (booth_enc == 3'b101 || booth_enc == 3'b110) ? -m_shift0 : 16'b0;

    // Ready signal generation
    assign rdy = (state == DONE);

    // FSM state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            prev_lsb <= 1'b0;
            iteration <= 4'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    p <= 16'b0;
                    iteration <= 4'b0;
                end
                
                COMPUTE: begin
                    p <= p + partial_product;
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    iteration <= iteration + 1;
                end
                
                DONE: begin
                    // Hold final value
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = COMPUTE;
            COMPUTE: next_state = (iteration == 3) ? DONE : COMPUTE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule