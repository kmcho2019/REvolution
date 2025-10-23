module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage [0:3];
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8 bits + 1 for Booth
    reg [1:0] pipe_ctr;
    reg [2:0] state;

    // FSM states
    localparam IDLE = 3'b000;
    localparam LOAD = 3'b001;
    localparam STAGE1 = 3'b010;
    localparam STAGE2 = 3'b011;
    localparam STAGE3 = 3'b100;
    localparam STAGE4 = 3'b101;
    localparam DONE = 3'b110;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            multiplicand <= 16'b0;
            multiplier <= 9'b0;
            p <= 16'b0;
            rdy <= 1'b0;
            pipe_ctr <= 2'b0;
            state <= IDLE;
            
            // Clear pipeline stages
            for (integer i = 0; i < 4; i = i + 1)
                stage[i] <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Initialize operation
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {b, 1'b0};  // Add LSB=0 for Booth
                    p <= 16'b0;
                    rdy <= 1'b0;
                    state <= LOAD;
                end
                
                LOAD: begin
                    // Check for early termination
                    if (multiplier[8:1] == 8'b0 || multiplier[8:1] == 8'hFF) begin
                        p <= (multiplier[8]) ? -multiplicand : multiplicand;
                        state <= DONE;
                    end else begin
                        state <= STAGE1;
                        pipe_ctr <= 2'b0;
                    end
                end
                
                STAGE1, STAGE2, STAGE3, STAGE4: begin
                    // Process current 2 bits
                    case (multiplier[2:0])
                        3'b000, 3'b111: stage[pipe_ctr] <= p;
                        3'b001, 3'b010: stage[pipe_ctr] <= p + multiplicand;
                        3'b011:         stage[pipe_ctr] <= p + (multiplicand << 1);
                        3'b100:         stage[pipe_ctr] <= p - (multiplicand << 1);
                        3'b101, 3'b110: stage[pipe_ctr] <= p - multiplicand;
                    endcase
                    
                    // Update multiplier and pipeline
                    multiplier <= multiplier >>> 2;
                    p <= stage[pipe_ctr];
                    
                    // State transition
                    if (pipe_ctr == 2'b11) begin
                        state <= DONE;
                    end else begin
                        pipe_ctr <= pipe_ctr + 1;
                        state <= state + 1;
                    end
                end
                
                DONE: begin
                    // Final result and ready signal
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule