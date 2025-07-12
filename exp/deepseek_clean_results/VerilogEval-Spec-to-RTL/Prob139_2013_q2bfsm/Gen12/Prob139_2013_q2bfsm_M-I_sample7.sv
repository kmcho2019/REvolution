module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 0;
localparam STATE_B = 1;
localparam STATE_C = 2;
localparam STATE_D = 3;
localparam STATE_E = 4;  // Permanent g=1
localparam STATE_F = 5;  // Permanent g=0

reg [2:0] state;
reg [2:0] x_shift;      // 3-bit shift register for x inputs
reg [1:0] timeout_cnt;   // Counter for 2-cycle timeout

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_shift <= 3'b000;
        timeout_cnt <= 0;
    end else begin
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        // Default outputs
        f <= 0;
        g <= 0;
        
        case (state)
            STATE_A: begin
                state <= STATE_B;
                f <= 1;  // Set f=1 for one cycle
            end
            
            STATE_B: begin
                if (x_shift == 3'b101) begin  // Detected 1-0-1 sequence
                    state <= STATE_D;
                    g <= 1;
                    timeout_cnt <= 0;
                end
            end
            
            STATE_D: begin
                g <= 1;
                if (y) begin
                    state <= STATE_E;  // Permanent g=1
                end else if (timeout_cnt == 1) begin
                    state <= STATE_F;  // Permanent g=0
                end else begin
                    timeout_cnt <= timeout_cnt + 1;
                end
            end
            
            STATE_E: begin
                g <= 1;  // Permanent g=1 until reset
            end
            
            STATE_F: begin
                g <= 0;  // Permanent g=0 until reset
            end
        endcase
    end
end

endmodule