module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding for simpler decoding
parameter [2:0] S_RED    = 3'b001;
parameter [2:0] S_YELLOW = 3'b010;
parameter [2:0] S_GREEN  = 3'b100;

reg [2:0] state;
reg [5:0] cnt;
wire cnt_enable;

// Counter enable logic - only decrement when not in transition
assign cnt_enable = !((state == S_RED && cnt == 1) ||
                     (state == S_YELLOW && cnt == 1) ||
                     (state == S_GREEN && cnt == 1) ||
                     (state == S_GREEN && pass_request && cnt > 10));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
        cnt <= 6'd10;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Update counter
        if (cnt_enable) begin
            cnt <= cnt - 1;
        end

        // State transitions
        case (state)
            S_RED: begin
                if (cnt == 1) begin
                    state <= S_GREEN;
                    cnt <= 6'd60;
                end
            end
            S_YELLOW: begin
                if (cnt == 1) begin
                    state <= S_RED;
                    cnt <= 6'd10;
                end
            end
            S_GREEN: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 6'd10;
                end
                if (cnt == 1) begin
                    state <= S_YELLOW;
                    cnt <= 6'd5;
                end
            end
        endcase

        // Registered outputs
        red    <= (state == S_RED);
        yellow <= (state == S_YELLOW);
        green  <= (state == S_GREEN);
    end
end

// Registered clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock <= 6'd10;
    end else begin
        clock <= cnt;
    end
end

endmodule