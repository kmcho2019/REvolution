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
    localparam IDLE = 2'b00;
    localparam SEC  = 2'b01;
    localparam MIN  = 2'b10;
    localparam HOUR = 2'b11;

    reg [1:0] state;
    reg pm_reg;
    reg [7:0] ss_reg;  // BCD format: tens(7:4) + ones(3:0)
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;

    // BCD increment helper signals
    wire ss_inc = (ss_reg[3:0] == 4'd9);
    wire mm_inc = (mm_reg[3:0] == 4'd9);
    wire hh_inc = (hh_reg[3:0] == 4'd9);

    // State machine and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pm_reg <= 1'b0;
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
        end
        else if (ena) begin
            case (state)
                IDLE: state <= SEC;
                
                SEC: begin
                    if (ss_inc) begin
                        ss_reg[3:0] <= 4'd0;
                        if (ss_reg[7:4] == 4'd5) begin
                            ss_reg[7:4] <= 4'd0;
                            state <= MIN;
                        end
                        else begin
                            ss_reg[7:4] <= ss_reg[7:4] + 1;
                            state <= IDLE;
                        end
                    end
                    else begin
                        ss_reg[3:0] <= ss_reg[3:0] + 1;
                        state <= IDLE;
                    end
                end
                
                MIN: begin
                    if (mm_inc) begin
                        mm_reg[3:0] <= 4'd0;
                        if (mm_reg[7:4] == 4'd5) begin
                            mm_reg[7:4] <= 4'd0;
                            state <= HOUR;
                        end
                        else begin
                            mm_reg[7:4] <= mm_reg[7:4] + 1;
                            state <= IDLE;
                        end
                    end
                    else begin
                        mm_reg[3:0] <= mm_reg[3:0] + 1;
                        state <= IDLE;
                    end
                end
                
                HOUR: begin
                    // Special handling for 12-hour format
                    if (hh_reg == 8'h12) begin
                        hh_reg <= 8'h01;
                    end
                    else if (hh_inc) begin
                        hh_reg[7:4] <= 4'd1;
                        hh_reg[3:0] <= 4'd0;
                    end
                    else begin
                        hh_reg[3:0] <= hh_reg[3:0] + 1;
                    end
                    
                    // Toggle PM at 11->12 transition
                    if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule