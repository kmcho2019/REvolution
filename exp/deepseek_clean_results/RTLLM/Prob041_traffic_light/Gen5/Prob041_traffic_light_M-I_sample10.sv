module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output [1:0] light  // 00: off, 01: red, 10: yellow, 11: green
);

// One-hot state encoding
localparam [3:0] S1_RED    = 4'b0001;
localparam [3:0] S2_YELLOW = 4'b0010;
localparam [3:0] S3_GREEN  = 4'b0100;

// Timing parameters
localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] REQ_TIME    = 6'd10;

reg [3:0] current_state, next_state;
reg [5:0] cnt;
reg cnt_en;  // Counter enable for clock gating
reg [5:0] cnt_load;  // Parallel load value for counter

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S1_RED;
    end else begin
        current_state <= next_state;
    end
end

// Next state and counter control logic
always @(*) begin
    next_state = current_state;
    cnt_en = 1'b1;
    cnt_load = cnt;
    
    case (current_state)
        S1_RED: begin
            if (cnt == 6'd1) begin
                next_state = S3_GREEN;
                cnt_load = GREEN_TIME;
            end
        end
        S2_YELLOW: begin
            if (cnt == 6'd1) begin
                next_state = S1_RED;
                cnt_load = RED_TIME;
            end
        end
        S3_GREEN: begin
            if (pass_request && (cnt > REQ_TIME)) begin
                cnt_load = REQ_TIME;
            end else if (cnt == 6'd1) begin
                next_state = S2_YELLOW;
                cnt_load = YELLOW_TIME;
            end
        end
        default: next_state = S1_RED;
    endcase
end

// Counter with parallel load and clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        if (cnt == 6'd1 || (current_state == S3_GREEN && pass_request && cnt > REQ_TIME))
            cnt <= cnt_load;
        else
            cnt <= cnt - 1'b1;
    end
end

// Output encoding (only one light active at a time)
assign light = (current_state == S1_RED) ? 2'b01 :
               (current_state == S2_YELLOW) ? 2'b10 :
               (current_state == S3_GREEN) ? 2'b11 : 2'b00;

assign clock = cnt;

endmodule