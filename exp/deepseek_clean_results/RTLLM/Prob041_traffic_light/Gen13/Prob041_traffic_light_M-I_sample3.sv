module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [6:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter TIMING = {
    7'd60,  // GREEN_TIME
    7'd5,   // YELLOW_TIME
    7'd10   // RED_TIME
};
parameter MIN_GREEN = 7'd10;

// State encoding (one-hot)
reg [2:0] state;
reg [6:0] cnt;
reg cnt_en;  // Counter enable for clock gating

// State definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

// Synchronized reset
reg rst_n_sync;
always @(posedge clk) begin
    rst_n_sync <= rst_n;
end

always @(posedge clk or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
        state <= RED;
        cnt <= TIMING[6:0];  // RED_TIME
        cnt_en <= 1'b1;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Default assignments
        cnt_en <= 1'b1;
        
        // Handle state transitions
        if (cnt == 0) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= TIMING[20:14];  // GREEN_TIME
                    {red, yellow, green} <= 3'b001;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= TIMING[6:0];  // RED_TIME
                    {red, yellow, green} <= 3'b100;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= TIMING[13:7];  // YELLOW_TIME
                    {red, yellow, green} <= 3'b010;
                end
                default: begin
                    state <= RED;
                    cnt <= TIMING[6:0];  // RED_TIME
                    {red, yellow, green} <= 3'b100;
                end
            endcase
        end else begin
            // Handle pedestrian request
            if (pass_request && state == GREEN && cnt > MIN_GREEN) begin
                cnt <= MIN_GREEN;
            end else if (cnt_en) begin
                cnt <= cnt - 1;
            end
            
            // Clock gating logic
            if (state == GREEN && cnt > MIN_GREEN && !pass_request) begin
                cnt_en <= 1'b0;  // Stop counter when not needed
            end
        end
    end
end

// Registered outputs
always @(posedge clk) begin
    clock <= cnt;
end

endmodule