module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (8 bits for clarity)
    localparam [7:0] RED_TIME     = 8'd10;
    localparam [7:0] YELLOW_TIME  = 8'd5;
    localparam [7:0] GREEN_TIME   = 8'd60;
    localparam [7:0] GREEN_SHORT  = 8'd10;

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RED_ST  = 2'd1,
        GREEN_ST= 2'd2,
        YELLOW_ST= 2'd3
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // Outputs combinationally from state
    assign red    = (state == RED_ST);
    assign green  = (state == GREEN_ST);
    assign yellow = (state == YELLOW_ST);

    // Synchronous process: state, counter, and ped_shortened registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Combinational next state and counter logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case(state)
            IDLE: begin
                // Immediately move to RED state and initialize counter
                next_state = RED_ST;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end

            RED_ST: begin
                // Decrement counter until zero
                if (cnt == 0) begin
                    next_state = GREEN_ST;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0; // Reset ped_shortened entering green
                end else begin
                    next_cnt = cnt - 1;
                    next_ped_shortened = 1'b0; // ensure reset in red
                end
            end

            GREEN_ST: begin
                if (cnt == 0) begin
                    // Transition to yellow
                    next_state = YELLOW_ST;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0; // Reset shortening flag leaving green
                end else begin
                    // If pedestrian button pressed, and not shortened yet, and remaining green > 10, shorten
                    if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                        next_cnt = GREEN_SHORT;
                        next_ped_shortened = 1'b1;
                    end else begin
                        next_cnt = cnt - 1;
                        next_ped_shortened = ped_shortened;
                    end
                end
            end

            YELLOW_ST: begin
                if (cnt == 0) begin
                    next_state = RED_ST;
                    next_cnt = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_cnt = cnt - 1;
                    next_ped_shortened = 1'b0;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 8'd0;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Assign clock output synchronously from cnt register (to output 8 bits)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule