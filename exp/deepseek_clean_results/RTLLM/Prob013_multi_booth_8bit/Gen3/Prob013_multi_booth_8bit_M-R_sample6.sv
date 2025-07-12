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
    localparam STEP1 = 2'b01;
    localparam STEP2 = 2'b10;
    localparam STEP3 = 2'b11;
    
    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg prev_bit;
    reg [15:0] next_p;
    
    // Combinational logic for Booth operations
    always @(*) begin
        case ({multiplier[1:0], prev_bit})
            3'b000, 3'b111: next_p = p;             // No operation
            3'b001, 3'b010: next_p = p + multiplicand;  // +1×
            3'b011: next_p = p + (multiplicand << 1);   // +2×
            3'b100: next_p = p - (multiplicand << 1);   // -2×
            3'b101, 3'b110: next_p = p - multiplicand;  // -1×
            default: next_p = p;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            prev_bit <= 1'b0;
            state <= IDLE;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    p <= 16'b0;
                    prev_bit <= 1'b0;
                    state <= STEP1;
                    rdy <= 1'b0;
                end
                
                STEP1: begin
                    p <= next_p;
                    multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                    multiplicand <= multiplicand << 2;
                    prev_bit <= multiplier[1];
                    state <= STEP2;
                end
                
                STEP2: begin
                    p <= next_p;
                    multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                    multiplicand <= multiplicand << 2;
                    prev_bit <= multiplier[1];
                    state <= STEP3;
                end
                
                STEP3: begin
                    p <= next_p;
                    multiplier <= { {2{multiplier[15]}}, multiplier[15:2] };
                    multiplicand <= multiplicand << 2;
                    prev_bit <= multiplier[1];
                    state <= IDLE;
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule