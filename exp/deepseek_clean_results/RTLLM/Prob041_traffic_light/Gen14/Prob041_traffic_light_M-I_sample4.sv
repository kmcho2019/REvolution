module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [6:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter [6:0] 
    GREEN_TIME  = 7'd60,
    YELLOW_TIME = 7'd5,
    RED_TIME    = 7'd10,
    MIN_GREEN   = 7'd10;

// State encoding
reg [1:0] state;
reg [6:0] cnt;
wire counter_en;

// State definitions
localparam 
    RED    = 2'b00,
    YELLOW = 2'b01,
    GREEN  = 2'b10;

// Clock gating logic
assign counter_en = (cnt > 1) || 
                   ((state == GREEN) && pass_request && (cnt > MIN_GREEN));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // State transitions
        if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            endcase
        end
        // Counter logic with clock gating
        else if (counter_en) begin
            if (state == GREEN && pass_request && cnt > MIN_GREEN)
                cnt <= MIN_GREEN;
            else
                cnt <= cnt - 1;
        end
    end
end

// Direct output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule