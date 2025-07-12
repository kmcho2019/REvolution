module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

    // Shared signals
    wire sec_max = (Secs == 6'd59);
    wire min_max = (Mins == 6'd59);
    wire hour_max = (Hours == 6'd23);
    wire min_inc = sec_max;
    wire hour_inc = sec_max & min_max;

    // Gray coding for lower bits of seconds
    reg [5:0] sec_gray;
    wire [5:0] sec_binary;
    
    // Convert Gray to binary for comparison
    assign sec_binary[5] = sec_gray[5];
    assign sec_binary[4] = sec_gray[4] ^ sec_binary[5];
    assign sec_binary[3] = sec_gray[3] ^ sec_binary[4];
    assign sec_binary[2] = sec_gray[2] ^ sec_binary[3];
    assign sec_binary[1] = sec_gray[1] ^ sec_binary[2];
    assign sec_binary[0] = sec_gray[0] ^ sec_binary[1];

    // Seconds counter with Gray coding
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            sec_gray <= 6'd0;
        end else begin
            if (sec_binary == 6'd59) begin
                sec_gray <= 6'd0;
            end else begin
                // Increment using Gray code
                case (sec_gray[1:0])
                    2'b00: sec_gray <= {sec_gray[5:2], 2'b01};
                    2'b01: sec_gray <= {sec_gray[5:2], 2'b11};
                    2'b11: sec_gray <= {sec_gray[5:2], 2'b10};
                    2'b10: sec_gray <= {sec_gray[5:3], ~sec_gray[2], 2'b00};
                endcase
            end
        end
    end

    // Minutes counter with clock gating
    reg min_enable;
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
            min_enable <= 1'b0;
        end else begin
            min_enable <= sec_max;
            if (min_enable) begin
                Mins <= min_max ? 6'd0 : Mins + 6'd1;
            end
        end
    end

    // Hours counter with clock gating
    reg hour_enable;
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
            hour_enable <= 1'b0;
        end else begin
            hour_enable <= hour_inc;
            if (hour_enable) begin
                Hours <= hour_max ? 6'd0 : Hours + 6'd1;
            end
        end
    end

    // Output assignment
    assign Secs = sec_binary;

endmodule