module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding using 2 bits
localparam idle     = 2'b00;
localparam s1_red   = 2'b01;
localparam s2_yellow= 2'b10;
localparam s3_green = 2'b11;

// State durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam GREEN_SHORT = 8'd10;

reg [1:0] state;
reg [7:0] cnt;
reg shortened; // flag indicating if green has been shortened in this green period

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd0;
        shortened <= 1'b0;
    end else begin
        case(state)
            idle: begin
                // Transition immediately to red state with red time loaded
                state <= s1_red;
                cnt <= RED_TIME;
                shortened <= 1'b0;
            end

            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    cnt <= GREEN_TIME;
                    shortened <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end

            s3_green: begin
                if (pass_request && !shortened && cnt > GREEN_SHORT) begin
                    // Shorten green time to 10 if possible
                    cnt <= GREEN_SHORT;
                    shortened <= 1'b1;
                end else if (cnt == 0) begin
                    state <= s2_yellow;
                    cnt <= YELLOW_TIME;
                    shortened <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end

            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    cnt <= RED_TIME;
                    shortened <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end

            default: begin
                // In case of unknown state, reset to idle
                state <= idle;
                cnt <= 8'd0;
                shortened <= 1'b0;
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case(state)
        s1_red: begin
            red = 1'b1;
            yellow = 1'b0;
            green = 1'b0;
        end
        s2_yellow: begin
            red = 1'b0;
            yellow = 1'b1;
            green = 1'b0;
        end
        s3_green: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b1;
        end
        default: begin
            // For idle or unexpected states, all off
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    endcase
    clock = cnt;
end

endmodule