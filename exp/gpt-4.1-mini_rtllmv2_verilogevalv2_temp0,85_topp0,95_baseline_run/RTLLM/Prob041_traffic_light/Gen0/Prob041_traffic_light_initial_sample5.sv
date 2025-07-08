module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);
    // State encoding
    parameter idle     = 2'b00,
              s1_red  = 2'b01,
              s2_yellow = 2'b10,
              s3_green  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] cnt;
    reg p_red, p_yellow, p_green;

    // State transition and next state logic, output next values
    always @(*) begin
        // default next state and outputs
        next_state = state;
        p_red = 0;
        p_yellow = 0;
        p_green = 0;

        case(state)
            idle: begin
                // All lights off
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
                // Transition immediately to s1_red
                next_state = s1_red;
            end

            s1_red: begin
                p_red = 1;
                if(cnt == 0)
                    next_state = s3_green;
                else
                    next_state = s1_red;
            end

            s2_yellow: begin
                p_yellow = 1;
                if(cnt == 0)
                    next_state = s1_red;
                else
                    next_state = s2_yellow;
            end

            s3_green: begin
                p_green = 1;
                if(cnt == 0)
                    next_state = s2_yellow;
                else
                    next_state = s3_green;
            end

            default: begin
                next_state = idle;
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
        endcase
    end

    // Counter and timing control
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 10;
            state <= idle;
            red <= 0;
            yellow <= 0;
            green <= 0;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            // Update state
            state <= next_state;

            // Counter logic
            if(state != next_state) begin
                // State just changed, reset counter according to new state
                case(next_state)
                    idle: cnt <= 10; // not used but safe
                    s1_red: cnt <= 10;
                    s2_yellow: cnt <= 5;
                    s3_green: cnt <= 60;
                    default: cnt <= 10;
                endcase
            end else begin
                // If green light and pass_request is pressed
                if(pass_request && p_green) begin
                    // Shorten green time to 10 if remaining >10
                    if(cnt > 10)
                        cnt <= 10;
                    else
                        cnt <= cnt - 1;
                end else begin
                    cnt <= (cnt > 0) ? cnt - 1 : 0;
                end
            end

            // Output signal update
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    // Assign output clock to current counter value
    always @(*) begin
        clock = cnt;
    end

endmodule