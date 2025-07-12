module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_mcand;
    reg [8:0] stage1_mplier;
    reg [15:0] stage1_pp [0:3];  // Partial products
    reg [1:0] stage1_counter;
    
    reg [15:0] stage2_acc;
    reg [1:0] stage2_counter;
    
    // State machine
    typedef enum {IDLE, PROCESSING, DONE} state_t;
    state_t state;

    // Booth encoding and partial product generation
    always @(posedge clk) begin
        if (reset) begin
            stage1_mcand <= {{8{a[7]}}, a};
            stage1_mplier <= {b, 1'b0};
            stage1_counter <= 0;
            
            // Immediate ready for zero inputs
            if (a == 0 || b == 0) begin
                p <= 0;
                rdy <= 1;
                state <= DONE;
            end else begin
                rdy <= 0;
                state <= PROCESSING;
            end
        end
        else if (state == PROCESSING) begin
            // Generate all 4 possible partial products in parallel
            stage1_pp[0] <= stage1_mcand;
            stage1_pp[1] <= stage1_mcand << 1;
            stage1_pp[2] <= ~(stage1_mcand << 1) + 1;  // Negative 2x
            stage1_pp[3] <= ~stage1_mcand + 1;         // Negative 1x
            
            // Update for next cycle
            stage1_mcand <= stage1_mcand << 2;
            stage1_mplier <= stage1_mplier >> 2;
            stage1_counter <= stage1_counter + 1;
            
            if (stage1_counter == 3) begin
                state <= DONE;
                rdy <= 1;
            end
        end
    end

    // Accumulation stage
    always @(posedge clk) begin
        if (reset) begin
            stage2_acc <= 0;
            stage2_counter <= 0;
        end
        else if (state == PROCESSING) begin
            // Select partial product based on Booth encoding
            case (stage1_mplier[2:0])
                3'b001, 3'b010: stage2_acc <= stage2_acc + stage1_pp[0];
                3'b011:         stage2_acc <= stage2_acc + stage1_pp[1];
                3'b100:         stage2_acc <= stage2_acc + stage1_pp[2];
                3'b101, 3'b110: stage2_acc <= stage2_acc + stage1_pp[3];
                default:        stage2_acc <= stage2_acc;
            endcase
            
            // Final output update
            if (stage1_counter == 3) begin
                p <= stage2_acc;
            end
        end
    end

endmodule