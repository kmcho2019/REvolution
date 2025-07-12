module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding
parameter [2:0] RED_ST    = 3'b001;
parameter [2:0] YELLOW_ST = 3'b010;
parameter [2:0] GREEN_ST  = 3'b100;

reg [2:0] state;
reg [5:0] red_cnt;
reg [5:0] yellow_cnt;
reg [5:0] green_cnt;
reg [5:0] saved_green;
reg       pending_request;

// Output current active counter
assign clock = (state == RED_ST)    ? red_cnt :
              (state == YELLOW_ST) ? yellow_cnt :
              green_cnt;

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_ST;
        red_cnt <= 6'd10;
        yellow_cnt <= 6'd5;
        green_cnt <= 6'd60;
        saved_green <= 6'd0;
        pending_request <= 1'b0;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Handle pedestrian requests
        if (pass_request && state == GREEN_ST) begin
            pending_request <= 1'b1;
            if (green_cnt > 6'd10) begin
                saved_green <= green_cnt - 6'd10;
                green_cnt <= 6'd10;
            end
        end

        // State transitions and counters
        case (state)
            RED_ST: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
                red_cnt <= red_cnt - 6'd1;
                if (red_cnt == 6'd1) begin
                    state <= GREEN_ST;
                    // Restore saved green time if available
                    green_cnt <= (saved_green > 0) ? saved_green : 6'd60;
                    saved_green <= 6'd0;
                end
            end
            
            YELLOW_ST: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
                yellow_cnt <= yellow_cnt - 6'd1;
                if (yellow_cnt == 6'd1) begin
                    state <= RED_ST;
                    red_cnt <= 6'd10;
                end
            end
            
            GREEN_ST: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
                green_cnt <= green_cnt - 6'd1;
                if (green_cnt == 6'd1) begin
                    state <= YELLOW_ST;
                    yellow_cnt <= 6'd5;
                    pending_request <= 1'b0;
                end
            end
            
            default: begin
                state <= RED_ST;
                red_cnt <= 6'd10;
            end
        endcase
    end
end

endmodule