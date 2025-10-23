module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// One-hot state encoding
reg [2:0] current_state, next_state;
reg [5:0] cnt;
reg cnt_en;

// State definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

// State transition logic (combinational)
always @(*) begin
    next_state = current_state;
    cnt_en = 1'b1;
    
    case (current_state)
        RED: begin
            if (cnt == 1) next_state = GREEN;
        end
        YELLOW: begin
            if (cnt == 1) next_state = RED;
        end
        GREEN: begin
            // Handle pedestrian request
            if (pass_request && cnt > MIN_GREEN) begin
                cnt_en = (cnt == MIN_GREEN) ? 1'b0 : 1'b1;
                if (cnt == MIN_GREEN) next_state = YELLOW;
            end
            else if (cnt == 1) begin
                next_state = YELLOW;
            end
        end
        default: next_state = RED;
    endcase
end

// Counter logic with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        if (cnt == 1) begin
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

// State register and output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= RED_TIME;
    end else begin
        current_state <= next_state;
        clock <= cnt;
        
        // Registered outputs
        red <= (next_state == RED);
        yellow <= (next_state == YELLOW);
        green <= (next_state == GREEN);
    end
end

endmodule