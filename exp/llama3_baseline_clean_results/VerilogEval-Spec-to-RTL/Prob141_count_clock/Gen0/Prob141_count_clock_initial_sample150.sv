module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the initial values for the counters
localparam INITIAL_HH = 8'h12; // 12 in BCD
localparam INITIAL_MM = 8'h00; // 0 in BCD
localparam INITIAL_SS = 8'h00; // 0 in BCD

// Internal signals to store the current state of the counters
reg [7:0] current_hh;
reg [7:0] current_mm;
reg [7:0] current_ss;

// Reset the counters to their initial values when reset is asserted
always @(posedge clk) begin
    if (reset) begin
        current_hh <= INITIAL_HH;
        current_mm <= INITIAL_MM;
        current_ss <= INITIAL_SS;
    end
    // Increment the counters when ena is asserted
    else if (ena) begin
        // Increment the seconds counter
        if (current_ss == 8'h59) begin
            current_ss <= INITIAL_SS;
            // Increment the minutes counter
            if (current_mm == 8'h59) begin
                current_mm <= INITIAL_MM;
                // Increment the hours counter
                if (current_hh == 8'h12) begin
                    current_hh <= 8'h01; // 1 in BCD
                end else begin
                    current_hh <= current_hh + 1;
                end
            end else begin
                current_mm <= current_mm + 1;
            end
        end else begin
            current_ss <= current_ss + 1;
        end
    end
end

// Assign the current state of the counters to the output ports
assign hh = current_hh;
assign mm = current_mm;
assign ss = current_ss;

// Determine the pm signal based on the current hour value
assign pm = (current_hh[3] == 1'b1); // pm is asserted if the hour is greater than 12

endmodule