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
    typedef enum logic [1:0] {
        IDLE,
        SEC_INCR,
        MIN_INCR,
        HOUR_INCR
    } state_t;

    state_t current_state, next_state;

    // Unified counter storage
    reg [5:0] sec_count;  // 0-59
    reg [5:0] min_count;  // 0-59
    reg [3:0] hour_count; // 0-11 (0=12, 1=1,...11=11)
    reg pm_reg;

    // Predictive BCD values
    wire [3:0] next_sec_ones, next_sec_tens;
    wire [3:0] next_min_ones, next_min_tens;
    wire [3:0] next_hr_ones, next_hr_tens;

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            sec_count <= 6'd0;
            min_count <= 6'd0;
            hour_count <= 4'd11; // Starts at 12 (represented as 0)
            pm_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                SEC_INCR: begin
                    sec_count <= (sec_count == 6'd59) ? 6'd0 : sec_count + 1;
                end
                MIN_INCR: begin
                    min_count <= (min_count == 6'd59) ? 6'd0 : min_count + 1;
                end
                HOUR_INCR: begin
                    hour_count <= (hour_count == 4'd11) ? 4'd0 : hour_count + 1;
                    // PM toggles when hour_count wraps from 11 to 0
                    if (hour_count == 4'd11) pm_reg <= ~pm_reg;
                end
                default: ; // IDLE state does nothing
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = IDLE;
        if (ena) begin
            next_state = SEC_INCR;
            if (current_state == SEC_INCR && sec_count == 6'd59)
                next_state = MIN_INCR;
            if (current_state == MIN_INCR && min_count == 6'd59)
                next_state = HOUR_INCR;
        end
    end

    // Predictive BCD conversion (combinational)
    assign next_sec_ones = (sec_count[3:0] == 4'd9) ? 4'd0 : sec_count[3:0] + 1;
    assign next_sec_tens = (sec_count[3:0] == 4'd9) ? 
                          (sec_count[5:4] == 2'd5) ? 2'd0 : sec_count[5:4] + 1 : 
                          sec_count[5:4];

    assign next_min_ones = (min_count[3:0] == 4'd9) ? 4'd0 : min_count[3:0] + 1;
    assign next_min_tens = (min_count[3:0] == 4'd9) ? 
                          (min_count[5:4] == 2'd5) ? 2'd0 : min_count[5:4] + 1 : 
                          min_count[5:4];

    // Special hour conversion (0 → 12, 1-11 → 1-11)
    assign next_hr_ones = (hour_count == 4'd11) ? 4'd2 : 
                         (hour_count == 4'd0) ? 4'd2 : 
                         hour_count + 1;
    assign next_hr_tens = (hour_count == 4'd11 || hour_count == 4'd0) ? 4'd1 : 4'd0;

    // Output assignments using predictive values
    assign ss = (current_state == SEC_INCR) ? {next_sec_tens, next_sec_ones} : 
               {sec_count[5:4], sec_count[3:0]};
    assign mm = (current_state == MIN_INCR) ? {next_min_tens, next_min_ones} : 
               {min_count[5:4], min_count[3:0]};
    assign hh = (current_state == HOUR_INCR) ? {next_hr_tens, next_hr_ones} : 
               (hour_count == 4'd0) ? 8'h12 : 
               {1'b0, hour_count};
    assign pm = pm_reg;

endmodule