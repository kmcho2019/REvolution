module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed time representation: {hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones}
    reg [23:0] time_reg;

    // BCD increment function
    function [3:0] bcd_inc;
        input [3:0] digit;
        input carry_in;
        begin
            bcd_inc = (digit == 4'd9 && carry_in) ? 4'd0 : 
                     (carry_in ? digit + 1 : digit);
        end
    endfunction

    // Time increment logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            time_reg <= 24'h120000;
        end else if (ena) begin
            // Seconds increment
            time_reg[3:0] <= bcd_inc(time_reg[3:0], 1'b1);  // Always increment seconds
            
            // Handle second rollover
            if (time_reg[3:0] == 4'd9) begin
                time_reg[7:4] <= bcd_inc(time_reg[7:4], 1'b1);
                if (time_reg[7:4] == 4'd5 && time_reg[3:0] == 4'd9) begin
                    time_reg[15:8] <= {bcd_inc(time_reg[15:12], 1'b1), bcd_inc(time_reg[11:8], 
                                      (time_reg[15:12] == 4'd5 && time_reg[11:8] == 4'd9))};
                    
                    // Handle hour rollover
                    if (time_reg[15:8] == 8'h59) begin
                        if (time_reg[23:20] == 4'd1 && time_reg[19:16] == 4'd2) begin
                            // 12 -> 1 transition
                            time_reg[23:16] <= 8'h01;
                        end else if (time_reg[19:16] == 4'd9) begin
                            // 9 -> 10 transition
                            time_reg[23:16] <= {time_reg[23:20] + 1, 4'd0};
                        end else begin
                            // Normal hour increment
                            time_reg[19:16] <= time_reg[19:16] + 1;
                        end
                    end
                end
            end
        end
    end

    // Output assignments
    assign pm = (time_reg[23:16] >= 8'h12) && (time_reg[23:16] < 8'h24);
    assign hh = time_reg[23:16];
    assign mm = time_reg[15:8];
    assign ss = time_reg[7:0];

endmodule