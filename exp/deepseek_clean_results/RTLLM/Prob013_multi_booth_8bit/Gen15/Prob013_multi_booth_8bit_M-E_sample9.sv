module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_mcand, stage2_mcand;
    reg [7:0] stage1_mplier, stage2_mplier;
    reg [15:0] stage1_acc, stage2_acc;
    reg [1:0] stage1_ctr, stage2_ctr;
    reg stage1_prev, stage2_prev;
    reg stage1_zero, stage2_zero;
    
    // Control signals
    reg [1:0] opcode;
    reg [15:0] operand;
    reg exec_phase;
    reg [2:0] state;

    // Zero detection logic
    wire zero_detect = (b == 8'b0) || (b == 8'hFF) || (a == 8'b0);

    always @(posedge clk) begin
        if (reset) begin
            // Initialize pipeline
            stage1_mcand <= {{8{a[7]}}, a};
            stage1_mplier <= b;
            stage1_acc <= 16'b0;
            stage1_ctr <= 2'b0;
            stage1_prev <= 1'b0;
            stage1_zero <= zero_detect;
            
            stage2_mcand <= 16'b0;
            stage2_mplier <= 8'b0;
            stage2_acc <= 16'b0;
            stage2_ctr <= 2'b0;
            stage2_prev <= 1'b0;
            stage2_zero <= 1'b0;
            
            p <= 16'b0;
            rdy <= 1'b0;
            exec_phase <= 1'b0;
            state <= 3'b000;
        end else begin
            // Pipeline stage 1: Decode and prepare operation
            if (!stage1_zero && !rdy) begin
                case ({stage1_mplier[1:0], stage1_prev})
                    3'b000, 3'b111: begin opcode = 2'b00; operand = 16'b0; end
                    3'b001, 3'b010: begin opcode = 2'b01; operand = stage1_mcand; end
                    3'b011: begin opcode = 2'b10; operand = stage1_mcand << 1; end
                    3'b100: begin opcode = 2'b11; operand = stage1_mcand << 1; end
                    3'b101, 3'b110: begin opcode = 2'b11; operand = stage1_mcand; end
                endcase
            end else begin
                opcode = 2'b00;
                operand = 16'b0;
            end

            // Pipeline stage 2: Execute operation and shift
            case (opcode)
                2'b01: stage2_acc <= stage2_acc + operand;  // Add
                2'b11: stage2_acc <= stage2_acc - operand;  // Subtract
                default: stage2_acc <= stage2_acc;         // No op
            endcase
            
            stage2_mcand <= stage1_mcand << 2;
            stage2_mplier <= stage1_mplier >> 2;
            stage2_prev <= stage1_mplier[1];
            stage2_ctr <= stage1_ctr + 1;
            stage2_zero <= stage1_zero;

            // Update pipeline registers
            stage1_mcand <= stage2_mcand;
            stage1_mplier <= stage2_mplier;
            stage1_acc <= stage2_acc;
            stage1_ctr <= stage2_ctr;
            stage1_prev <= stage2_prev;
            stage1_zero <= stage2_zero;

            // Output and control
            if (stage1_zero) begin
                p <= 16'b0;
                rdy <= 1'b1;
            end else if (stage2_ctr == 2'b11) begin
                p <= stage2_acc;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule