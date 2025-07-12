module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse state
localparam STATE_C = 2'd2;  // Monitoring x sequence
localparam STATE_D = 2'd3;  // Monitoring y with timeout
localparam STATE_E = 2'd4;  // Permanent state (g=1 or g=0)

reg [1:0] state;
reg [1:0] x_shift;  // Shift register for 1-0-1 sequence
reg timeout_flag;   // Single bit for 2-cycle timeout

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_shift <= 2'b00;
        timeout_flag <= 0;
    end
    else begin
        case (state)
            STATE_A: begin
                f <= 1;
                state <= STATE_B;
            end
            
            STATE_B: begin
                f <= 0;
                state <= STATE_C;
            end
            
            STATE_C: begin
                x_shift <= {x_shift[0], x};
                if (x_shift == 2'b01 && x == 1'b1) begin  // Detected 1-0-1
                    g <= 1;
                    state <= STATE_D;
                    timeout_flag <= 0;
                end
            end
            
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;  // Permanent g=1
                end
                else if (timeout_flag) begin
                    g <= 0;
                    state <= STATE_E;  // Permanent g=0
                end
                else begin
                    timeout_flag <= 1;  // Mark first timeout cycle
                end
            end
            
            STATE_E: begin
                // Permanent state - no changes
            end
        endcase
    end
end

endmodule