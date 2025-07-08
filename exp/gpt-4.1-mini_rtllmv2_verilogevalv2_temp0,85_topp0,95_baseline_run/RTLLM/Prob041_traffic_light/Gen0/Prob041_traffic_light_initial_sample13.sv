module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
parameter idle     = 2'b00;
parameter s1_red   = 2'b01;
parameter s2_yellow= 2'b10;
parameter s3_green = 2'b11;

reg [7:0] cnt;
reg [1:0] state;

reg p_red, p_yellow, p_green;

// State transition and output logic combinational
always @(*) begin
    // Default outputs
    p_red = 1'b0;
    p_yellow = 1'b0;
    p_green = 1'b0;

    case(state)
        idle: begin
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

// State transition logic - synchronous
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: state <= s1_red; // Immediately go to red from idle
            s1_red: begin
                if(cnt == 8'd0)
                    state <= s3_green;
                else
                    state <= s1_red;
            end
            s2_yellow: begin
                if(cnt == 8'd0)
                    state <= s1_red;
                else
                    state <= s2_yellow;
            end
            s3_green: begin
                if(cnt == 8'd0)
                    state <= s2_yellow;
                else
                    state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter logic - synchronous
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 8'd10;
    end else begin
        // Pedestrian button handling: if green and pass_request and cnt > 10, shorten to 10
        if(pass_request && (state == s3_green) && (cnt > 8'd10)) begin
            cnt <= 8'd10;
        end
        else if(state == s3_green) begin
            // normal green decrement
            if(cnt != 8'd0)
                cnt <= cnt - 1;
        end
        else if(state == s2_yellow) begin
            if(cnt == 8'd0) begin
                // do nothing, wait for state transition to reset cnt
                cnt <= cnt;
            end else
                cnt <= cnt - 1;
        end
        else if(state == s1_red) begin
            if(cnt == 8'd0) begin
                cnt <= cnt;
            end else
                cnt <= cnt - 1;
        end
        else if(state == idle) begin
            cnt <= 8'd10;
        end
        else begin
            cnt <= cnt - 1;
        end

        // Detect state change and load appropriate cnt value
        // Using previous p_* to detect light transitions
        // But here we do it synchronously after state transition

        // If state just changed to s1_red and cnt==0, load 10
        // If state just changed to s2_yellow and cnt==0, load 5
        // If state just changed to s3_green and cnt==0, load 60
        if(cnt == 8'd0) begin
            case(state)
                s1_red: cnt <= 8'd10;
                s2_yellow: cnt <= 8'd5;
                s3_green: cnt <= 8'd60;
                default: cnt <= 8'd10;
            endcase
        end
    end
end

assign clock = cnt;

// Output register update
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
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