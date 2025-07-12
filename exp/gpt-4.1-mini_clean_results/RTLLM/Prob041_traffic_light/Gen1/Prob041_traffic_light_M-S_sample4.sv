module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam IDLE    = 2'd0;
localparam RED     = 2'd1;
localparam GREEN   = 2'd2;
localparam YELLOW  = 2'd3;

reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

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
    // Default assignments
    next_state = state;
    next_cnt = cnt;

    case(state)
        IDLE: begin
            // Immediately go to RED state with cnt=10
            next_state = RED;
            next_cnt = 8'd10;
        end

        RED: begin
            if (cnt == 0) begin
                next_state = GREEN;
                next_cnt = 8'd60;
            end else begin
                next_cnt = cnt - 1;
            end
        end

        GREEN: begin
            if (pass_request && (cnt > 8'd10)) begin
                // Shorten green time to 10 cycles remaining
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

// Output logic based on state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        case(state)
            RED: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            GREEN: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            YELLOW: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            default: begin // IDLE or others
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
        clock <= cnt;
    end
end

endmodule