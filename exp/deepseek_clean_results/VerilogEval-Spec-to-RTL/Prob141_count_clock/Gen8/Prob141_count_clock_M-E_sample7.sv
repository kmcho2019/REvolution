module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        SEC_INC,
        MIN_INC,
        HR_INC
    } state_t;
    
    state_t current_state, next_state;
    
    // Counter signals
    wire sec_rollover, min_rollover;
    wire [7:0] sec_count, min_count;
    reg [3:0] hour_bin; // Binary hour counter (1-12)
    reg pm_reg;
    
    // Instantiate seconds counter (00-59)
    BCD_Counter #(.MAX(59)) seconds_counter (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .count(sec_count),
        .rollover(sec_rollover)
    );
    
    // Instantiate minutes counter (00-59)
    BCD_Counter #(.MAX(59)) minutes_counter (
        .clk(clk),
        .reset(reset),
        .ena(sec_rollover),
        .count(min_count),
        .rollover(min_rollover)
    );
    
    // State machine for hour counting and PM detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            hour_bin <= 4'd12;
            pm_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: if (ena) next_state <= SEC_INC;
                SEC_INC: begin
                    next_state <= IDLE;
                    if (sec_rollover) next_state <= MIN_INC;
                end
                MIN_INC: begin
                    next_state <= IDLE;
                    if (min_rollover) next_state <= HR_INC;
                end
                HR_INC: begin
                    next_state <= IDLE;
                    // Handle hour increment and AM/PM toggle
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                        pm_reg <= ~pm_reg;
                    end else begin
                        hour_bin <= hour_bin + 1;
                    end
                end
            endcase
        end
    end
    
    // Convert binary hour to BCD
    wire [7:0] hour_bcd;
    assign hour_bcd = (hour_bin < 10) ? {4'd0, hour_bin} : {4'd1, hour_bin - 4'd10};
    
    assign ss = sec_count;
    assign mm = min_count;
    assign hh = hour_bcd;
    assign pm = pm_reg;

endmodule

// Parameterized BCD counter module
module BCD_Counter #(
    parameter MAX = 59
)(
    input clk,
    input reset,
    input ena,
    output reg [7:0] count,
    output reg rollover
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 8'h00;
            rollover <= 1'b0;
        end else if (ena) begin
            rollover <= 1'b0;
            if (count[3:0] == 4'd9) begin
                count[3:0] <= 4'd0;
                if (count[7:4] == (MAX/10)) begin
                    count[7:4] <= 4'd0;
                    rollover <= 1'b1;
                end else begin
                    count[7:4] <= count[7:4] + 1;
                end
            end else begin
                count[3:0] <= count[3:0] + 1;
            end
        end
    end
endmodule