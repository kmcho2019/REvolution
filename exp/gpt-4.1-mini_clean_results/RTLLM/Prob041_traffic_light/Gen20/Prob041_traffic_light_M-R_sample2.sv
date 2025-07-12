module traffic_light (
    input          rst_n,
    input          clk,
    input          pass_request,
    output [7:0]   clock,
    output         red,
    output         yellow,
    output         green
);

    // Timing parameters
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] GREEN_SHORT = 8'd10;

    // One-hot encoded states
    reg state_red, state_green, state_yellow;
    reg ped_shortened;
    reg [7:0] cnt;

    // Next state signals (combinational)
    reg next_red, next_green, next_yellow;
    reg next_ped_shortened;
    reg [7:0] next_cnt;

    // Decode current state
    wire in_red    = state_red;
    wire in_green  = state_green;
    wire in_yellow = state_yellow;

    // Determine if timer enabled (countdown)
    wire timer_en = (cnt != 0);

    // Next state logic
    always @(*) begin
        // Default keep current states and signals
        next_red    = state_red;
        next_green  = state_green;
        next_yellow = state_yellow;
        next_ped_shortened = ped_shortened;
        next_cnt = cnt;

        if (in_red) begin
            next_ped_shortened = 1'b0; // Reset shortening flag in red
            if (cnt == 0) begin
                // Transition: RED -> GREEN
                next_red    = 1'b0;
                next_green  = 1'b1;
                next_yellow = 1'b0;
                next_cnt = GREEN_TIME;
                next_ped_shortened = 1'b0;
            end else if (timer_en) begin
                next_cnt = cnt - 1;
            end
        end else if (in_green) begin
            // Pedestrian request shortens green if not yet shortened and remaining > 10
            if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                next_cnt = GREEN_SHORT;
                next_ped_shortened = 1'b1;
            end else if (cnt == 0) begin
                // Transition: GREEN -> YELLOW
                next_red    = 1'b0;
                next_green  = 1'b0;
                next_yellow = 1'b1;
                next_cnt = YELLOW_TIME;
                next_ped_shortened = 1'b0; // Reset when leaving green
            end else if (timer_en) begin
                next_cnt = cnt - 1;
            end
        end else if (in_yellow) begin
            next_ped_shortened = 1'b0; // Reset shortening flag in yellow
            if (cnt == 0) begin
                // Transition: YELLOW -> RED
                next_red    = 1'b1;
                next_green  = 1'b0;
                next_yellow = 1'b0;
                next_cnt = RED_TIME;
            end else if (timer_en) begin
                next_cnt = cnt - 1;
            end
        end else begin
            // Undefined state: reset to RED
            next_red    = 1'b1;
            next_green  = 1'b0;
            next_yellow = 1'b0;
            next_cnt    = RED_TIME;
            next_ped_shortened = 1'b0;
        end
    end

    // Sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_red     <= 1'b1;
            state_green   <= 1'b0;
            state_yellow  <= 1'b0;
            ped_shortened <= 1'b0;
            cnt           <= RED_TIME;
        end else begin
            state_red     <= next_red;
            state_green   <= next_green;
            state_yellow  <= next_yellow;
            ped_shortened <= next_ped_shortened;
            cnt           <= next_cnt;
        end
    end

    // Outputs
    assign red    = state_red;
    assign green  = state_green;
    assign yellow = state_yellow;

    assign clock = cnt;

endmodule