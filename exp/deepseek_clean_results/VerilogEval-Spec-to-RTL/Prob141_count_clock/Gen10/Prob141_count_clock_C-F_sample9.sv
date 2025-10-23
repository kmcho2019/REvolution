module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 1-12 counter
    wire sec_rollover, min_rollover;

    // Gated rollover signals
    assign sec_rollover = ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
    assign min_rollover = sec_rollover && (min_ones == 4'd9) && (min_tens == 4'd5);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (sec_rollover) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm <= 1'b0;
        end else if (min_rollover) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
            
            // Toggle PM when hour changes from 11 to 12
            if (hour == 4'd11)
                pm <= ~pm;
        end
    end

    // Output registers (updated every clock for better timing)
    always @(posedge clk) begin
        ss <= {sec_tens, sec_ones};
        mm <= {min_tens, min_ones};
        // Convert hour to BCD
        hh <= (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    end

endmodule