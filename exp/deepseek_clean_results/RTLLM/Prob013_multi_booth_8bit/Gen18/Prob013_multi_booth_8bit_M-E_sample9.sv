module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp [0:3];  // Partial products (x0, x1, x2, x3)
    reg [15:0] stage2_accum;
    reg [7:0] stage2_multiplier;
    reg [1:0] stage2_counter;
    reg stage2_prev_lsb;
    
    // Control signals
    reg [1:0] state;
    reg early_term;
    wire [1:0] booth_sel;
    
    // Constants
    localparam IDLE = 2'b00;
    localparam STAGE1 = 2'b01;
    localparam STAGE2 = 2'b10;
    localparam DONE = 2'b11;
    
    // Booth encoding selection
    assign booth_sel = {stage2_multiplier[1:0], stage2_prev_lsb};
    
    // Early termination detection
    always @(*) begin
        early_term = (stage2_multiplier == 8'b0) && (state == STAGE2);
    end
    
    // Stage 1: Pre-compute all possible partial products
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!reset) begin
                        // Pre-compute all partial products
                        stage1_pp[0] <= 16'b0;  // x0
                        stage1_pp[1] <= {{8{a[7]}}, a};  // x1
                        stage1_pp[2] <= {{8{a[7]}}, a} << 1;  // x2
                        stage1_pp[3] <= ({{8{a[7]}}, a} << 1) + {{8{a[7]}}, a};  // x3
                        
                        stage2_accum <= 16'b0;
                        stage2_multiplier <= b;
                        stage2_prev_lsb <= 1'b0;
                        stage2_counter <= 2'b0;
                        
                        state <= STAGE1;
                        rdy <= 1'b0;
                    end
                end
                
                STAGE1: begin
                    // Pipeline register update
                    state <= STAGE2;
                end
                
                STAGE2: begin
                    // Select partial product based on Booth encoding
                    case (booth_sel)
                        3'b001, 3'b010: stage2_accum <= stage2_accum + stage1_pp[1];  // +x1
                        3'b011:         stage2_accum <= stage2_accum + stage1_pp[2];  // +x2
                        3'b100:         stage2_accum <= stage2_accum - stage1_pp[2];  // -x2
                        3'b101, 3'b110: stage2_accum <= stage2_accum - stage1_pp[1];  // -x1
                        default:       stage2_accum <= stage2_accum;  // +x0
                    endcase
                    
                    // Update multiplier and counter
                    stage2_multiplier <= stage2_multiplier >> 2;
                    stage2_prev_lsb <= stage2_multiplier[1];
                    stage2_counter <= stage2_counter + 1;
                    
                    // State transition logic
                    if (early_term || (stage2_counter == 2'b11))
                        state <= DONE;
                    else
                        state <= STAGE1;  // Loop back for next pair of bits
                end
                
                DONE: begin
                    p <= stage2_accum;
                    rdy <= 1'b1;
                    if (reset)
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule