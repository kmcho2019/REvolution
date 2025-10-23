module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding using parameters as requested
localparam [1:0]
    idle      = 2'd0,
    s1_red    = 2'd1,
    s2_yellow = 2'd2,
    s3_green  = 2'd3;

// Timing constants per specification
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [7:0] cnt;
reg [1:0] state;
reg       shortened_green; // Flag to ensure green is shortened only once per green cycle

// State transition and output combinational block
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state           <= idle;
        cnt             <= 8'd10;  // Initial counter value per instructions
        shortened_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                // Outputs off by default; transition immediately to s1_red
                state           <= s1_red;
                cnt             <= RED_TIME;
                shortened_green <= 1'b0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state           <= s3_green;
                    cnt             <= GREEN_TIME;
                    shortened_green <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                // Handle pedestrian request only once and only if remaining > 10
                if (pass_request && !shortened_green && cnt > SHORT_GREEN) begin
                    cnt             <= SHORT_GREEN;
                    shortened_green <= 1'b1;
                end else if (cnt == 0) begin
                    state           <= s2_yellow;
                    cnt             <= YELLOW_TIME;
                    shortened_green <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state           <= s1_red;
                    cnt             <= RED_TIME;
                    shortened_green <= 1'b0;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                // Safety fallback to idle state
                state           <= idle;
                cnt             <= 8'd10;
                shortened_green <= 1'b0;
            end
        endcase
    end
end

// Output logic: outputs reflect the current state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        clock <= cnt;
        case (state)
            idle: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            s1_red: begin
                red    <= 1'b1;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            s2_yellow: begin
                red    <= 1'b0;
                yellow <= 1'b1;
                green  <= 1'b0;
            end
            s3_green: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b1;
            end
            default: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
        endcase
    end
end

endmodule