module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State machine states
    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE = 2'b10;
    
    reg [1:0] state;
    reg [2:0] cycle_count;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] accumulator;
    
    // Pre-computed values
    wire [15:0] m_neg = -{ {8{a[7]}}, a };
    wire [15:0] m_pos = { {8{a[7]}}, a };
    wire [15:0] m2_neg = m_neg << 1;
    wire [15:0] m2_pos = m_pos << 1;
    wire [15:0] m4_neg = m_neg << 2;
    wire [15:0] m4_pos = m_pos << 2;
    
    // Booth encoding groups
    wire [2:0] booth_group;
    wire is_last_group;
    
    // Speculative computation mux
    reg [15:0] partial_product;
    
    assign booth_group = (cycle_count == 0) ? {multiplier[2:0], 1'b0} :
                         (cycle_count == 1) ? {multiplier[5:3], multiplier[2]} :
                         {multiplier[7:6], multiplier[5], 1'b0};
    
    assign is_last_group = (cycle_count == 2) || 
                          ((cycle_count == 1) && (&multiplier[7:3] == multiplier[7])) ||
                          ((cycle_count == 0) && (&multiplier[7:6] == multiplier[7]));
    
    always @(*) begin
        case (booth_group)
            3'b000, 3'b111: partial_product = 16'b0;
            3'b001: partial_product = m_pos;
            3'b010: partial_product = m_pos;
            3'b011: partial_product = m2_pos;
            3'b100: partial_product = m2_neg;
            3'b101: partial_product = m_neg;
            3'b110: partial_product = m_neg;
            default: partial_product = 16'b0;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'b0;
            accumulator <= 16'b0;
            cycle_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    multiplicand <= { {8{a[7]}}, a };
                    multiplier <= { {8{b[7]}}, b };
                    accumulator <= 16'b0;
                    cycle_count <= 3'b0;
                    state <= COMPUTE;
                    rdy <= 1'b0;
                end
                
                COMPUTE: begin
                    // Shift accumulator by 3 bits for next group
                    if (cycle_count != 0) 
                        accumulator <= (accumulator << 3) + partial_product;
                    else
                        accumulator <= partial_product;
                    
                    if (is_last_group) begin
                        state <= DONE;
                        p <= (accumulator << 3) + partial_product;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule