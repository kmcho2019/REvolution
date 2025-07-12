module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD registers
    reg [7:0] ss_reg;  // seconds (00-59)
    reg [7:0] mm_reg;  // minutes (00-59)
    reg [11:0] hour_state; // one-hot hour state (1-12)
    reg pm_reg;

    // Registered rollover signals
    reg sec_rollover;
    reg min_rollover;

    // Output registers
    reg [7:0] hh_reg;
    reg [7:0] mm_reg_out;
    reg [7:0] ss_reg_out;

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg_out;
    assign ss = ss_reg_out;

    // State machine for hour counter and all other logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all counters
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hour_state <= 12'b000000000001; // 12 o'clock
            pm_reg <= 1'b0;
            
            // Reset rollover flags
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
            
            // Reset outputs
            hh_reg <= 8'h12;
            mm_reg_out <= 8'h00;
            ss_reg_out <= 8'h00;
        end
        else begin
            // Default rollover values
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
            
            // Seconds counter
            if (ena) begin
                if (ss_reg[3:0] == 4'd9) begin
                    ss_reg[3:0] <= 4'd0;
                    if (ss_reg[7:4] == 4'd5) begin
                        ss_reg[7:4] <= 4'd0;
                        sec_rollover <= 1'b1;
                    end
                    else begin
                        ss_reg[7:4] <= ss_reg[7:4] + 1;
                    end
                end
                else begin
                    ss_reg[3:0] <= ss_reg[3:0] + 1;
                end
            end
            
            // Minutes counter
            if (ena && sec_rollover) begin
                if (mm_reg[3:0] == 4'd9) begin
                    mm_reg[3:0] <= 4'd0;
                    if (mm_reg[7:4] == 4'd5) begin
                        mm_reg[7:4] <= 4'd0;
                        min_rollover <= 1'b1;
                    end
                    else begin
                        mm_reg[7:4] <= mm_reg[7:4] + 1;
                    end
                end
                else begin
                    mm_reg[3:0] <= mm_reg[3:0] + 1;
                end
            end
            
            // Hours counter (state machine)
            if (ena && sec_rollover && min_rollover) begin
                case (hour_state)
                    12'b000000000001: hour_state <= 12'b000000000010; // 12->1
                    12'b000000000010: hour_state <= 12'b000000000100; // 1->2
                    12'b000000000100: hour_state <= 12'b000000001000; // 2->3
                    12'b000000001000: hour_state <= 12'b000000010000; // 3->4
                    12'b000000010000: hour_state <= 12'b000000100000; // 4->5
                    12'b000000100000: hour_state <= 12'b000001000000; // 5->6
                    12'b000001000000: hour_state <= 12'b000010000000; // 6->7
                    12'b000010000000: hour_state <= 12'b000100000000; // 7->8
                    12'b000100000000: hour_state <= 12'b001000000000; // 8->9
                    12'b001000000000: hour_state <= 12'b010000000000; // 9->10
                    12'b010000000000: hour_state <= 12'b100000000000; // 10->11
                    12'b100000000000: begin
                        hour_state <= 12'b000000000001; // 11->12
                        pm_reg <= ~pm_reg; // Toggle PM at 11->12 transition
                    end
                    default: hour_state <= 12'b000000000001;
                endcase
            end
            
            // Update output registers
            ss_reg_out <= ss_reg;
            mm_reg_out <= mm_reg;
            
            // Convert hour state to BCD
            case (hour_state)
                12'b000000000001: hh_reg <= 8'h12;
                12'b000000000010: hh_reg <= 8'h01;
                12'b000000000100: hh_reg <= 8'h02;
                12'b000000001000: hh_reg <= 8'h03;
                12'b000000010000: hh_reg <= 8'h04;
                12'b000000100000: hh_reg <= 8'h05;
                12'b000001000000: hh_reg <= 8'h06;
                12'b000010000000: hh_reg <= 8'h07;
                12'b000100000000: hh_reg <= 8'h08;
                12'b001000000000: hh_reg <= 8'h09;
                12'b010000000000: hh_reg <= 8'h10;
                12'b100000000000: hh_reg <= 8'h11;
                default: hh_reg <= 8'h12;
            endcase
        end
    end

endmodule