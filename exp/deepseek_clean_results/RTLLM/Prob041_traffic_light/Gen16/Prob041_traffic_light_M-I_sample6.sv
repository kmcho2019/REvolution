module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// One-hot state encoding
reg [2:0] current_state, next_state;
reg [5:0] cnt;
reg cnt_en;  // Counter enable for clock gating

// State definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

// Shared comparator signals
wire cnt_is_1 = (cnt == 1);
wire green_active = current_state[2];
wire yellow_active = current_state[1];
wire red_active = current_state[0];
wire pedestrian_condition = (green_active && pass_request && (cnt > MIN_GREEN));

// State transition logic (combinational)
always @(*) begin
    next_state = current_state;
    cnt_en = 1'b1;  // Default counter enabled
    
    case (1'b1)  // Synthesis will optimize this to parallel case
        current_state[0]: begin // RED
            if (cnt_is_1) begin
                next_state = GREEN;
                cnt_en = 1'b0; // Disable counter during transition
            end
        end
        current_state[1]: begin // YELLOW
            if (cnt_is_1) begin
                next_state = RED;
                cnt_en = 1'b0; // Disable counter during transition
            end
        end
        current_state[2]: begin // GREEN
            if (cnt_is_1) begin
                next_state = YELLOW;
                cnt_en = 1'b0; // Disable counter during transition
            end
        end
    endcase
end

// Counter logic (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        // Handle pedestrian request during green
        if (pedestrian_condition) begin
            cnt <= MIN_GREEN;
        end
        // Normal counter operation
        else if (cnt_is_1) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// State register (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
    end else begin
        current_state <= next_state;
    end
end

// Output assignments
assign clock = cnt;
assign red = red_active;
assign yellow = yellow_active;
assign green = green_active;

endmodule