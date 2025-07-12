module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    localparam idle     = 2'd0;
    localparam s1_red   = 2'd1;
    localparam s2_yellow= 2'd2;
    localparam s3_green = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= idle;
        else
            state <= next_state;
    end

    // Counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else if (state == s3_green && pass_request && cnt > GREEN_SHORT) begin
            cnt <= GREEN_SHORT;
        end else if (cnt != 0) begin
            cnt <= cnt - 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            idle:       next_state = s1_red;
            s1_red:     next_state = (cnt == 0) ? s3_green : s1_red;
            s3_green:   next_state = (cnt == 0) ? s2_yellow : s3_green;
            s2_yellow:  next_state = (cnt == 0) ? s1_red : s2_yellow;
            default:    next_state = idle;
        endcase
    end

    // Output and clock assign
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            case (state)
                s1_red: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    clock  <= cnt;
                end
                s2_yellow: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                    clock  <= cnt;
                end
                s3_green: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                    clock  <= cnt;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                    clock  <= 8'd0;
                end
            endcase
        end
    end

    // Initialize cnt for each state transition
    // This block resets counter when entering a new state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            case (next_state)
                s1_red:     if (state != s1_red) cnt <= RED_TIME;
                s2_yellow:  if (state != s2_yellow) cnt <= YELLOW_TIME;
                s3_green:   if (state != s3_green) cnt <= GREEN_TIME;
                default: ;
            endcase
        end
    end

endmodule