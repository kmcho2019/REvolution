module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Combined state register: [PM][HH][MM][SS]
    reg [25:0] time_state;

    // Next state calculation
    wire [25:0] next_state;
    assign next_state = reset ? 26'h01020000 : // 12:00:00 AM
                      ena ? increment_time(time_state) : time_state;

    // Time increment function
    function [25:0] increment_time(input [25:0] current);
        reg [7:0] new_ss;
        reg [7:0] new_mm;
        reg [7:0] new_hh;
        reg new_pm;
        
        // Default to current values
        new_ss = current[8:1];
        new_mm = current[16:9];
        new_hh = current[24:17];
        new_pm = current[25];
        
        // Increment seconds (BCD)
        if (new_ss[3:0] == 4'd9) begin
            new_ss[3:0] = 4'd0;
            if (new_ss[7:4] == 4'd5) begin
                new_ss[7:4] = 4'd0;
                // Increment minutes (BCD)
                if (new_mm[3:0] == 4'd9) begin
                    new_mm[3:0] = 4'd0;
                    if (new_mm[7:4] == 4'd5) begin
                        new_mm[7:4] = 4'd0;
                        // Increment hours (12-hour format)
                        if (new_hh == 8'h12) begin
                            new_hh = 8'h01;
                            new_pm = ~new_pm;
                        end
                        else if (new_hh[3:0] == 4'd9) begin
                            new_hh[3:0] = 4'd0;
                            new_hh[7:4] = new_hh[7:4] + 1;
                        end
                        else begin
                            new_hh[3:0] = new_hh[3:0] + 1;
                        end
                    end
                    else begin
                        new_mm[7:4] = new_mm[7:4] + 1;
                    end
                end
                else begin
                    new_mm[3:0] = new_mm[3:0] + 1;
                end
            end
            else begin
                new_ss[7:4] = new_ss[7:4] + 1;
            end
        end
        else begin
            new_ss[3:0] = new_ss[3:0] + 1;
        end
        
        increment_time = {new_pm, new_hh, new_mm, new_ss};
    endfunction

    // Update state on clock edge
    always @(posedge clk) begin
        time_state <= next_state;
    end

    // Output assignments
    assign pm = time_state[25];
    assign hh = time_state[24:17];
    assign mm = time_state[16:9];
    assign ss = time_state[8:1];

endmodule