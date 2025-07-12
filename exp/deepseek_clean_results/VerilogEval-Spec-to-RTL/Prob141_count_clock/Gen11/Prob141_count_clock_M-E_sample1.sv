module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        SEC_INC,
        MIN_INC,
        HOUR_INC
    } state_t;

    state_t current_state, next_state;

    // Unified counter
    reg [4:0] sec_count;  // 0-59 (6 bits needed)
    reg [5:0] min_count;  // 0-59 (6 bits needed)
    reg [3:0] hour_count; // 1-12 (4 bits)
    reg pm_reg;

    // Pre-computed BCD values for hours (01-12)
    wire [7:0] hour_bcd [1:12] = {
        8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06,
        8'h07, 8'h08, 8'h09, 8'h10, 8'h11, 8'h12
    };

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            sec_count <= 5'd0;
            min_count <= 6'd0;
            hour_count <= 4'd12;
            pm_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                SEC_INC: begin
                    if (sec_count == 5'd59) begin
                        sec_count <= 5'd0;
                    end else begin
                        sec_count <= sec_count + 1;
                    end
                end
                
                MIN_INC: begin
                    if (min_count == 6'd59) begin
                        min_count <= 6'd0;
                    end else begin
                        min_count <= min_count + 1;
                    end
                end
                
                HOUR_INC: begin
                    if (hour_count == 4'd12) begin
                        hour_count <= 4'd1;
                    end else begin
                        hour_count <= hour_count + 1;
                    end
                    
                    // Toggle PM when going from 11 to 12
                    if (hour_count == 4'd11) begin
                        pm_reg <= ~pm_reg;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = IDLE;
        if (ena) begin
            case (current_state)
                IDLE: next_state = SEC_INC;
                SEC_INC: next_state = (sec_count == 5'd59) ? MIN_INC : IDLE;
                MIN_INC: next_state = (min_count == 6'd59) ? HOUR_INC : IDLE;
                HOUR_INC: next_state = IDLE;
            endcase
        end
    end

    // Convert counters to BCD outputs
    assign ss = {sec_count[5:2], sec_count[3:0]};  // Simple mapping for seconds
    assign mm = {min_count[5:2], min_count[3:0]};  // Simple mapping for minutes
    assign hh = hour_bcd[hour_count];
    assign pm = pm_reg;

endmodule