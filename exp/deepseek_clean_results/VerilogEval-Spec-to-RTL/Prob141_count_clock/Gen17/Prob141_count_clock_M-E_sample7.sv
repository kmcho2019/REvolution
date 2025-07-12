module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Total states in 12-hour clock: 12*60*60*2 = 86400
    reg [16:0] counter;  // 17 bits can count up to 131072 (enough for 86400 states)
    wire [16:0] next_counter;

    // State decoding
    wire [5:0] seconds = next_counter % 60;
    wire [5:0] minutes = (next_counter / 60) % 60;
    wire [4:0] hours = (next_counter / 3600) % 12;
    wire pm_state = (next_counter >= 43200);  // PM if counter >= 12*60*60

    // Next state logic
    assign next_counter = reset ? 0 : 
                         (counter == 86399) ? 0 :  // 12:59:59 PM → 1:00:00 AM
                         ena ? counter + 1 : counter;

    // Output encoding (BCD)
    assign ss = {seconds[5:3], 1'b0, seconds[2:0]};  // Convert 6-bit to 2 BCD digits
    assign mm = {minutes[5:3], 1'b0, minutes[2:0]};  // Convert 6-bit to 2 BCD digits
    assign hh = (hours == 0) ? 8'h12 :              // 0 → 12
               {3'b000, hours[4], hours[3:0]};     // Convert 5-bit to 2 BCD digits
    assign pm = pm_state;

    // State register
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule