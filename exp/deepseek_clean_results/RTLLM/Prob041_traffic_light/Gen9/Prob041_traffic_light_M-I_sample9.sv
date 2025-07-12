module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding
parameter S_RED    = 3'b001;
parameter S_YELLOW = 3'b010;
parameter S_GREEN  = 3'b100;

reg [2:0] state;
reg [5:0] cnt;
reg cnt_en;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
        cnt <= 6'd10;
        cnt_en <= 1'b1;
    end else begin
        // State transitions
        case (state)
            S_RED: begin
                if (cnt == 6'd1) begin
                    state <= S_GREEN;
                    cnt <= 6'd60;
                    cnt_en <= 1'b1;
                end
            end
            S_YELLOW: begin
                if (cnt == 6'd1) begin
                    state <= S_RED;
                    cnt <= 6'd10;
                    cnt_en <= 1'b1;
                end
            end
            S_GREEN: begin
                if (pass_request && cnt > 6'd10) begin
                    cnt <= 6'd10;
                    cnt_en <= 1'b1;
                end
                if (cnt == 6'd1) begin
                    state <= S_YELLOW;
                    cnt <= 6'd5;
                    cnt_en <= 1'b1;
                end
            end
        endcase
        
        // Counter logic (only when enabled)
        if (cnt_en) begin
            cnt <= cnt - 1;
            cnt_en <= (cnt != 6'd1); // Disable counter at last cycle
        end
    end
end

// Registered outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {red, yellow, green} <= 3'b100;
        clock <= 6'd10;
    end else begin
        red    <= (state == S_RED);
        yellow <= (state == S_YELLOW);
        green  <= (state == S_GREEN);
        clock <= cnt;
    end
end

endmodule