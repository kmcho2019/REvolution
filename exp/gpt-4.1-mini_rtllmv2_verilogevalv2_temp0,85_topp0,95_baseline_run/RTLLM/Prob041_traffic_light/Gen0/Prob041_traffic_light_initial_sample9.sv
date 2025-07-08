module traffic_light (
    input  wire        rst_n,
    input  wire        clk,
    input  wire        pass_request,
    output wire [7:0]  clock,
    output reg         red,
    output reg         yellow,
    output reg         green
);

// State encoding
localparam [1:0]
    idle     = 2'b00,
    s1_red   = 2'b01,
    s2_yellow= 2'b10,
    s3_green = 2'b11;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and light next values
always @(*) begin
    // default next values
    p_red = 1'b0;
    p_yellow = 1'b0;
    p_green = 1'b0;

    case(state)
        idle: begin
            // all off
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
        s2_yellow: begin
            p_red = 1'b0;
            p_yellow = 1'b1;
            p_green = 1'b0;
        end
        s3_green: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b1;
        end
        default: begin
            p_red = 1'b0;
            p_yellow = 1'b0;
            p_green = 1'b0;
        end
    endcase
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: state <= s1_red;
            s1_red: begin
                if (cnt == 0) 
                    state <= s3_green;
                else 
                    state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 0)
                    state <= s1_red;
                else
                    state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 0)
                    state <= s2_yellow;
                else
                    state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter and special pedestrian button handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10; // start from red time as per recommendation
    end else begin
        case(state)
            idle: begin
                cnt <= 8'd10; // count 10 in idle (safe default)
            end
            s1_red: begin
                // At start of s1_red, set cnt to 10 if just entered
                // Detect entry by comparing previous state? 
                // To keep simple, check if cnt == 0 then load
                if (cnt == 0)
                    cnt <= 8'd10;
                else
                    cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0)
                    cnt <= 8'd5;
                else
                    cnt <= cnt - 1;
            end
            s3_green: begin
                // Pedestrian request logic:
                // If pass_request and cnt > 10, shorten cnt to 10
                if (pass_request && (cnt > 8'd10)) begin
                    cnt <= 8'd10;
                end else if (cnt == 0) begin
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: cnt <= 8'd10;
        endcase
    end
end

// Output the current counter value
assign clock = cnt;

// Update outputs on clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule