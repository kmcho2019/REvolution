module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output wire red,
    output wire yellow,
    output wire green
);

// State encoding
localparam IDLE   = 2'd0;
localparam RED    = 2'd1;
localparam GREEN  = 2'd2;
localparam YELLOW = 2'd3;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;
reg pass_req_latched; // Latch pass_request when entering green

// Latch pass_request only at green state entry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_req_latched <= 1'b0;
    end else if (state != GREEN && next_state == GREEN) begin
        pass_req_latched <= pass_request;
    end
end

// State and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 8'd0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Next state and counter logic
always @(*) begin
    next_state = state;
    next_cnt = cnt;

    case(state)
        IDLE: begin
            // Immediately transition to RED with 10 cycles
            next_state = RED;
            next_cnt = 8'd10;
        end

        RED: begin
            if (cnt == 0) begin
                next_state = GREEN;
                // Set green duration considering latched pass_request
                if (pass_req_latched)
                    next_cnt = 8'd10;
                else
                    next_cnt = 8'd60;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        GREEN: begin
            // If pass_req_latched and cnt > 10, shorten to 10
            if (pass_req_latched && cnt > 8'd10) begin
                next_cnt = 8'd10;
            end else if (cnt == 0) begin
                next_state = YELLOW;
                next_cnt = 8'd5;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        YELLOW: begin
            if (cnt == 0) begin
                next_state = RED;
                next_cnt = 8'd10;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        default: begin
            next_state = IDLE;
            next_cnt = 8'd0;
        end
    endcase
end

// Outputs assigned combinationally based on current state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

endmodule