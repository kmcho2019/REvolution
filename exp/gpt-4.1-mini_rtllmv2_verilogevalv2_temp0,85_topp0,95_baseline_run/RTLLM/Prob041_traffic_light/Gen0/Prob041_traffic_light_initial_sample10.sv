module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // Parameters for states
    parameter idle      = 2'b00;
    parameter s1_red    = 2'b01;
    parameter s2_yellow = 2'b10;
    parameter s3_green  = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // Next values for signals
    reg p_red, p_yellow, p_green;

    // State transition logic
    always @(*) begin
        // Default next state is current
        next_state = state;
        // Default next output signals 0
        p_red = 0;
        p_yellow = 0;
        p_green = 0;

        case(state)
            idle: begin
                // All signals off
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
                next_state = s1_red;
            end
            s1_red: begin
                p_red = 1;
                p_yellow = 0;
                p_green = 0;
                if (cnt == 8'd0) begin
                    next_state = s3_green;
                end else begin
                    next_state = s1_red;
                end
            end
            s2_yellow: begin
                p_red = 0;
                p_yellow = 1;
                p_green = 0;
                if (cnt == 8'd0) begin
                    next_state = s1_red;
                end else begin
                    next_state = s2_yellow;
                end
            end
            s3_green: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 1;
                if (cnt == 8'd0) begin
                    next_state = s2_yellow;
                end else begin
                    next_state = s3_green;
                end
            end
            default: begin
                next_state = idle;
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
        endcase
    end

    // Counter logic and state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10; // Start with red time on reset
        end else begin
            state <= next_state;

            if (state != next_state) begin
                // On state change, load appropriate count
                case(next_state)
                    s1_red:    cnt <= 8'd10;  // Red 10 clocks
                    s2_yellow: cnt <= 8'd5;   // Yellow 5 clocks
                    s3_green:  cnt <= 8'd60;  // Green 60 clocks
                    default:   cnt <= 8'd0;
                endcase
            end else begin
                // Same state: handle pass_request shortening green time
                if (state == s3_green) begin
                    if (pass_request && (cnt > 8'd10)) begin
                        cnt <= 8'd10;
                    end else if (cnt > 0) begin
                        cnt <= cnt - 1;
                    end
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
            end
        end
    end

    // Output register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 0;
            yellow <= 0;
            green  <= 0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
        end
    end

    // Assign the current count to output clock
    assign clock = cnt;

endmodule