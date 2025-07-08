module traffic_light(
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam idle     = 2'd0,
           s1_red   = 2'd1,
           s2_yellow= 2'd2,
           s3_green = 2'd3;

reg [1:0] state;
reg [7:0] cnt;

reg p_red, p_yellow, p_green;

always @(*) begin
    // Default next signals zero
    p_red    = 1'b0;
    p_yellow = 1'b0;
    p_green  = 1'b0;

    case(state)
        idle: begin
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
        s1_red: begin
            p_red = 1'b1;
        end
        s2_yellow: begin
            p_yellow = 1'b1;
        end
        s3_green: begin
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
    if(!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: state <= s1_red;
            s1_red: if(cnt == 8'd0) state <= s3_green;
                    else state <= s1_red;
            s2_yellow: if(cnt == 8'd0) state <= s1_red;
                       else state <= s2_yellow;
            s3_green: if(cnt == 8'd0) state <= s2_yellow;
                      else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Counter control and pedestrian button handling
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 8'd10; // start with red time
    end else begin
        // Handle counter update based on state and pass_request
        case(state)
            s1_red: begin
                if(cnt == 8'd0)
                    cnt <= 8'd60; // green time after red
                else
                    cnt <= cnt - 1;
            end
            s2_yellow: begin
                if(cnt == 8'd0)
                    cnt <= 8'd10; // red time after yellow
                else
                    cnt <= cnt - 1;
            end
            s3_green: begin
                // Pedestrian pass_request handling:
                // If pass_request and cnt > 10, set cnt to 10
                if(pass_request && (cnt > 8'd10))
                    cnt <= 8'd10;
                else if(cnt > 0)
                    cnt <= cnt - 1;
                else
                    cnt <= 8'd5; // yellow time after green
            end
            default: cnt <= 8'd10;
        endcase
    end
end

// Output assignment of signals and clock count
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        clock <= cnt;
    end
end

endmodule