module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters (localparam since they shouldn't change)
localparam GREEN_TIME = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME = 10;
localparam MIN_GREEN = 10;

// State encoding (binary)
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] current_state, next_state;
reg [5:0] next_cnt;
reg cnt_load;
reg [5:0] load_value;

// State transition logic (combinational)
always @(*) begin
    next_state = current_state;
    cnt_load = 1'b0;
    load_value = 6'd0;
    
    case (current_state)
        RED: begin
            if (clock == 6'd1) begin
                next_state = GREEN;
                cnt_load = 1'b1;
                load_value = GREEN_TIME;
            end
        end
        
        YELLOW: begin
            if (clock == 6'd1) begin
                next_state = RED;
                cnt_load = 1'b1;
                load_value = RED_TIME;
            end
        end
        
        GREEN: begin
            if (clock == 6'd1) begin
                next_state = YELLOW;
                cnt_load = 1'b1;
                load_value = YELLOW_TIME;
            end
        end
        
        default: begin
            next_state = RED;
            cnt_load = 1'b1;
            load_value = RED_TIME;
        end
    endcase
end

// Pedestrian request handling (combinational)
always @(*) begin
    next_cnt = clock - 1'b1;
    
    if (current_state == GREEN && pass_request && clock > MIN_GREEN) begin
        next_cnt = MIN_GREEN - 1'b1;
    end
    else if (cnt_load) begin
        next_cnt = load_value - 1'b1;
    end
end

// State and counter registers (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
        clock <= RED_TIME;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        current_state <= next_state;
        clock <= next_cnt;
        
        // Registered outputs
        red <= (next_state == RED);
        yellow <= (next_state == YELLOW);
        green <= (next_state == GREEN);
    end
end

endmodule