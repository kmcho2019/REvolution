module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Initialize the BCD counters
reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [3:0] min_tens;
reg [3:0] min_ones;
reg [3:0] sec_tens;
reg [3:0] sec_ones;

// Assign the BCD counters to the output ports
assign hh = {hour_tens, hour_ones};
assign mm = {min_tens, min_ones};
assign ss = {sec_tens, sec_ones};

// Define the initial values for the counters
initial begin
    hour_tens = 4'd1;
    hour_ones = 4'd2;
    min_tens = 4'd0;
    min_ones = 4'd0;
    sec_tens = 4'd0;
    sec_ones = 4'd0;
    pm = 1'b0;
end

// Define the counter logic
always @(posedge clk) begin
    if (reset) begin
        hour_tens <= 4'd1;
        hour_ones <= 4'd2;
        min_tens <= 4'd0;
        min_ones <= 4'd0;
        sec_tens <= 4'd0;
        sec_ones <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (sec_ones == 4'd9) begin
            sec_ones <= 4'd0;
            if (sec_tens == 4'd5) begin
                sec_tens <= 4'd0;
                // Increment minutes
                if (min_ones == 4'd9) begin
                    min_ones <= 4'd0;
                    if (min_tens == 4'd5) begin
                        min_tens <= 4'd0;
                        // Increment hours
                        if (hour_ones == 4'd9) begin
                            hour_ones <= 4'd0;
                            if (hour_tens == 4'd1 && pm == 1'b0) begin
                                hour_tens <= 4'd0;
                                pm <= 1'b1;
                            end else if (hour_tens == 4'd2 && pm == 1'b1) begin
                                hour_tens <= 4'd1;
                                pm <= 1'b0;
                            end else begin
                                hour_tens <= hour_tens + 1'b1;
                            end
                        end else begin
                            hour_ones <= hour_ones + 1'b1;
                        end
                    end else begin
                        min_tens <= min_tens + 1'b1;
                    end
                end else begin
                    min_ones <= min_ones + 1'b1;
                end
            end else begin
                sec_tens <= sec_tens + 1'b1;
            end
        end else begin
            sec_ones <= sec_ones + 1'b1;
        end
    end
end

endmodule