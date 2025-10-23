module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;
reg shortened_flag, next_shortened_flag;
reg timer_enable, state_enable, flag_enable;

// State and timer register update with enable to reduce toggling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        shortened_flag <= 1'b0;
    end else begin
        if(state_enable) state <= next_state;
        if(timer_enable) timer <= next_timer;
        if(flag_enable) shortened_flag <= next_shortened_flag;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    state_enable = 1'b0;

    if (timer == 8'd0) begin
        case(state)
            RED:    next_state = GREEN;
            GREEN:  next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
        state_enable = 1'b1;
    end
end

// Timer logic
always @(*) begin
    next_timer = timer;
    timer_enable = 1'b0;

    case(state)
        RED: begin
            if (timer == 8'd0) begin
                next_timer = GREEN_TIME;
                timer_enable = 1'b1;
            end else begin
                next_timer = timer - 1;
                timer_enable = 1'b1;
            end
        end
        YELLOW: begin
            if (timer == 8'd0) begin
                next_timer = RED_TIME;
                timer_enable = 1'b1;
            end else begin
                next_timer = timer - 1;
                timer_enable = 1'b1;
            end
        end
        GREEN: begin
            // Check if pass_request arrives and timer > SHORT_GREEN and not shortened yet
            if (pass_request && (timer > SHORT_GREEN) && !shortened_flag) begin
                next_timer = SHORT_GREEN;
                timer_enable = 1'b1;
            end else if (timer == 8'd0) begin
                next_timer = YELLOW_TIME;
                timer_enable = 1'b1;
            end else begin
                next_timer = timer - 1;
                timer_enable = 1'b1;
            end
        end
        default: begin
            next_timer = RED_TIME;
            timer_enable = 1'b1;
        end
    endcase
end

// shortened_flag logic
always @(*) begin
    next_shortened_flag = shortened_flag;
    flag_enable = 1'b0;

    if (state != GREEN) begin
        if (shortened_flag) begin
            next_shortened_flag = 1'b0;
            flag_enable = 1'b1;
        end
    end else begin
        if (pass_request && (timer > SHORT_GREEN) && !shortened_flag) begin
            next_shortened_flag = 1'b1;
            flag_enable = 1'b1;
        end
    end
end

// Output combinational logic
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule