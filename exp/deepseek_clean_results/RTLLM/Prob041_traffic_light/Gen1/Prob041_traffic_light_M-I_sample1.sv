module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter [1:0] IDLE = 2'b00;
parameter [1:0] RED = 2'b01;
parameter [1:0] YELLOW = 2'b10;
parameter [1:0] GREEN = 2'b11;

reg [1:0] state, next_state;
reg [7:0] cnt;

// State transition and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 8'd10;
    end else begin
        state <= next_state;
        
        // Counter logic
        if (state != next_state) begin
            // Load new counter value on state change
            case (next_state)
                RED: cnt <= 8'd10;
                YELLOW: cnt <= 8'd5;
                GREEN: cnt <= 8'd60;
                default: cnt <= 8'd10;
            endcase
        end else if (state == GREEN && pass_request && cnt > 8'd10) begin
            // Handle pedestrian request during green phase
            cnt <= 8'd10;
        end else if (cnt > 8'd0) begin
            // Normal countdown
            cnt <= cnt - 8'd1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = RED;
        RED: next_state = (cnt == 8'd0) ? GREEN : RED;
        YELLOW: next_state = (cnt == 8'd0) ? RED : YELLOW;
        GREEN: next_state = (cnt == 8'd0) ? YELLOW : GREEN;
        default: next_state = IDLE;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        clock <= cnt;
        case (state)
            RED: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            YELLOW: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            GREEN: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

endmodule