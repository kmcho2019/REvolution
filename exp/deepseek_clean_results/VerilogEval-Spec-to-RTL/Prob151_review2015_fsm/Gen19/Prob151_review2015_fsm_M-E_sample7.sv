module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // Pattern detection states
    localparam PD_IDLE = 1'b0;
    localparam PD_FOUND = 1'b1;
    
    // Timer control states
    localparam TC_IDLE = 2'b00;
    localparam TC_SHIFT = 2'b01;
    localparam TC_COUNT = 2'b10;
    localparam TC_DONE = 2'b11;

    reg pd_state;
    reg [1:0] tc_state;
    reg [3:0] pattern_window;
    reg [1:0] shift_counter;
    
    // Pattern detection FSM
    always @(posedge clk) begin
        if (reset) begin
            pd_state <= PD_IDLE;
            pattern_window <= 4'b0;
        end else begin
            pattern_window <= {pattern_window[2:0], data};
            
            if (pattern_window == 4'b1101) begin
                pd_state <= PD_FOUND;
            end else if (tc_state == TC_IDLE) begin
                pd_state <= PD_IDLE;
            end
        end
    end
    
    // Timer control FSM
    always @(posedge clk) begin
        if (reset) begin
            tc_state <= TC_IDLE;
            shift_counter <= 2'b0;
        end else begin
            case (tc_state)
                TC_IDLE: begin
                    if (pd_state == PD_FOUND) begin
                        tc_state <= TC_SHIFT;
                    end
                end
                
                TC_SHIFT: begin
                    if (shift_counter == 2'b11) begin
                        tc_state <= TC_COUNT;
                        shift_counter <= 2'b0;
                    end else begin
                        shift_counter <= shift_counter + 1;
                    end
                end
                
                TC_COUNT: begin
                    if (done_counting) begin
                        tc_state <= TC_DONE;
                    end
                end
                
                TC_DONE: begin
                    if (ack) begin
                        tc_state <= TC_IDLE;
                    end
                end
            endcase
        end
    end
    
    // Output assignments
    assign shift_ena = (tc_state == TC_SHIFT);
    assign counting = (tc_state == TC_COUNT);
    assign done = (tc_state == TC_DONE);
    
endmodule