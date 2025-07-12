module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Protocol phase tracking counter
    reg [3:0] phase_cnt;
    reg [7:0] data_reg;
    reg done_pulse;
    
    // Protocol phase boundaries
    localparam IDLE_PHASE  = 4'd0;
    localparam START_PHASE = 4'd1;
    localparam DATA_PHASE  = 4'd2;  // DATA_PHASE to DATA_PHASE+7
    localparam STOP_PHASE  = 4'd10;
    
    // Main sequential logic
    always @(posedge clk) begin
        if (reset) begin
            phase_cnt <= IDLE_PHASE;
            data_reg <= 8'b0;
            done_pulse <= 1'b0;
        end else begin
            // Default assignments
            done_pulse <= 1'b0;
            
            // Phase counter logic
            case (phase_cnt)
                IDLE_PHASE: begin
                    if (in == 1'b0) begin
                        phase_cnt <= START_PHASE;
                    end
                end
                
                START_PHASE: begin
                    phase_cnt <= DATA_PHASE;
                    data_reg <= {7'b0, in};  // First data bit
                end
                
                DATA_PHASE, DATA_PHASE+1, DATA_PHASE+2, DATA_PHASE+3,
                DATA_PHASE+4, DATA_PHASE+5, DATA_PHASE+6: begin
                    phase_cnt <= phase_cnt + 1;
                    data_reg <= {in, data_reg[7:1]};  // Shift in new bit
                end
                
                DATA_PHASE+7: begin
                    if (in == 1'b1) begin  // Early stop bit check
                        phase_cnt <= IDLE_PHASE;
                        done_pulse <= 1'b1;
                    end else begin
                        phase_cnt <= STOP_PHASE;
                    end
                end
                
                STOP_PHASE: begin
                    if (in == 1'b1) begin
                        phase_cnt <= IDLE_PHASE;
                    end
                end
                
                default: phase_cnt <= IDLE_PHASE;
            endcase
        end
    end

    assign done = done_pulse;

endmodule