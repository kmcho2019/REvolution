module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RED     = 2'b01,
        YELLOW  = 2'b10,
        GREEN   = 2'b11
    } state_t;

    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    state_t current_state, next_state;

    reg [7:0] cnt;
    reg cnt_reload_flag;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= RED;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            RED:    next_state = (cnt == 0) ? GREEN  : RED;
            GREEN:  next_state = (cnt == 0) ? YELLOW : GREEN;
            YELLOW: next_state = (cnt == 0) ? RED    : YELLOW;
            default:next_state = RED;
        endcase
    end

    // Counter logic: count down, reload on state change or pedestrian request
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= RED_TIME;
        end else begin
            if (cnt == 0) begin
                case (next_state)
                    RED:    cnt <= RED_TIME;
                    GREEN:  cnt <= GREEN_TIME;
                    YELLOW: cnt <= YELLOW_TIME;
                    default: cnt <= RED_TIME;
                endcase
            end else if ((current_state == GREEN) && pass_request && (cnt > SHORT_GREEN)) begin
                // Shorten green time on pedestrian request if remaining green time > 10
                cnt <= SHORT_GREEN;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    // Outputs assigned by combinational logic
    assign red    = (current_state == RED);
    assign yellow = (current_state == YELLOW);
    assign green  = (current_state == GREEN);
    assign clock  = cnt;

endmodule