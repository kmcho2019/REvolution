module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [7:0] ss_count;  // seconds in BCD (00-59)
    reg [7:0] mm_count;  // minutes in BCD (00-59)
    reg [7:0] hh_count;  // hours in BCD (01-12)
    
    wire ss_ena = ena;
    wire mm_ena = ena && (ss_count == 8'h59);
    wire hh_ena = mm_ena && (mm_count == 8'h59);
    wire pm_toggle = hh_ena && (hh_count == 8'h11);

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_count <= 8'h00;
        end else if (ss_ena) begin
            if (ss_count[3:0] == 4'h9) begin
                ss_count[3:0] <= 4'h0;
                if (ss_count[7:4] == 4'h5) begin
                    ss_count[7:4] <= 4'h0;
                end else begin
                    ss_count[7:4] <= ss_count[7:4] + 1;
                end
            end else begin
                ss_count[3:0] <= ss_count[3:0] + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_count <= 8'h00;
        end else if (mm_ena) begin
            if (mm_count[3:0] == 4'h9) begin
                mm_count[3:0] <= 4'h0;
                if (mm_count[7:4] == 4'h5) begin
                    mm_count[7:4] <= 4'h0;
                end else begin
                    mm_count[7:4] <= mm_count[7:4] + 1;
                end
            end else begin
                mm_count[3:0] <= mm_count[3:0] + 1;
            end
        end
    end

    // Hours counter (01-12) with PM toggle
    always @(posedge clk) begin
        if (reset) begin
            hh_count <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hh_ena) begin
            if (hh_count == 8'h12) begin
                hh_count <= 8'h01;
            end else if (hh_count[3:0] == 4'h9) begin
                hh_count <= {hh_count[7:4] + 1, 4'h0};
            end else begin
                hh_count[3:0] <= hh_count[3:0] + 1;
            end
            
            if (pm_toggle) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_count;
    assign mm = mm_count;
    assign hh = hh_count;

endmodule