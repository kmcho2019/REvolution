module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] iteration;  // 4 iterations needed (0-3)
    reg [15:0] multiplicand;
    reg [16:0] multiplier; // Extra bit for sign extension during shifts
    reg prev_lsb;

    // Booth encoding selection
    wire [2:0] booth_enc = {multiplier[1:0], prev_lsb};
    wire [15:0] partial_product;
    wire [15:0] m_neg = -multiplicand;
    wire [15:0] m_neg2 = -(multiplicand << 1);
    wire [15:0] m_pos2 = (multiplicand << 1);

    // Booth encoding case logic
    assign partial_product = 
        (booth_enc == 3'b000 || booth_enc == 3'b111) ? 16'b0 :
        (booth_enc == 3'b001 || booth_enc == 3'b010) ? multiplicand :
        (booth_enc == 3'b011) ? m_pos2 :
        (booth_enc == 3'b100) ? m_neg2 :
        (booth_enc == 3'b101 || booth_enc == 3'b110) ? m_neg : 16'b0;

    // FSM state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{9{b[7]}}, b[7:1]}; // Initialize with extra sign bit
            prev_lsb <= b[0];
            iteration <= 3'b0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    p <= 16'b0;
                    iteration <= 3'b0;
                    rdy <= 1'b0;
                end
                
                COMPUTE: begin
                    p <= p + partial_product;
                    multiplier <= {multiplier[16], multiplier[16:1]}; // Arithmetic right shift
                    prev_lsb <= multiplier[0];
                    iteration <= iteration + 1;
                end
                
                DONE: begin
                    rdy <= 1'b1;
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