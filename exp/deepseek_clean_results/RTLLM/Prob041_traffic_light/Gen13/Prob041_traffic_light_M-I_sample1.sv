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
localparam GREEN_TIME = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME = 10;
localparam MIN_GREEN = 10;

// State encoding
reg [1:0] state, next_state;
reg [5:0] cnt;
reg cnt_en;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b100;
        clock <= RED_TIME;
        cnt_en <= 1'b0;
    end else begin
        state <= next_state;
        
        // Clock gating for counter
        if (cnt_en) begin
            cnt <= cnt - 1;
            clock <= cnt - 1;
        end else begin
            clock <= cnt;
        end
        
        // Registered outputs
        red <= (next_state == RED);
        yellow <= (next_state == YELLOW);
        green <= (next_state == GREEN);
    end
end

always @(*) begin
    // Default assignments
    next_state = state;
    cnt_en = 1'b1;
    
    case (state)
        RED: begin
            if (cnt == 1) begin
                next_state = GREEN;
                cnt = GREEN_TIME;
                cnt_en = 1'b0;
            end
        end
        YELLOW: begin
            if (cnt == 1) begin
                next_state = RED;
                cnt = RED_TIME;
                cnt_en = 1'b0;
            end
        end
        GREEN: begin
            // Handle pedestrian request only at state boundaries
            if (pass_request && (cnt > MIN_GREEN)) begin
                cnt = MIN_GREEN;
                cnt_en = 1'b0;
            end
            else if (cnt == 1) begin
                next_state = YELLOW;
                cnt = YELLOW_TIME;
                cnt_en = 1'b0;
            end
        end
        default: next_state = RED;
    endcase
end

endmodule