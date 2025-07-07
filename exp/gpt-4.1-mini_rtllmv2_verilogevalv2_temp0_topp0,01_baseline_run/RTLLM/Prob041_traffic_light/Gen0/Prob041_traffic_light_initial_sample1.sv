module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam idle     = 2'd0,
           s1_red  = 2'd1,
           s2_yellow = 2'd2,
           s3_green = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and next output logic
always @(*) begin
    // Default next outputs
    p_red = 0;
    p_yellow = 0;
    p_green = 0;

    case(state)
        idle: begin
            // All off
            p_red = 0;
            p_yellow = 0;
            p_green = 0;
        end
        s1_red: begin
            p_red = 1;
            p_yellow = 0;
            p_green = 0;
        end
        s2_yellow: begin
            p_red = 0;
            p_yellow = 1;
            p_green = 0;
        end
        s3_green: begin
            p_red = 0;
            p_yellow = 0;
            p_green = 1;
        end
        default: begin
            p_red = 0;
            p_yellow = 0;
            p_green = 0;
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
                if (cnt == 0) state <= s3_green;
                else state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 0) state <= s1_red;
                else state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 0) state <= s2_yellow;
                else state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter logic with pedestrian button effect
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case(state)
            idle: cnt <= 10;
            s1_red: begin
                if (cnt == 0)
                    cnt <= 60; // next green duration
                else
                    cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0)
                    cnt <= 10; // next red duration
                else
                    cnt <= cnt - 1;
            end
            s3_green: begin
                // Pedestrian button shortens green if remaining > 10
                if (pass_request && cnt > 10)
                    cnt <= 10;
                else if (cnt == 0)
                    cnt <= 5; // next yellow duration
                else
                    cnt <= cnt - 1;
            end
            default: cnt <= 10;
        endcase
    end
end

// Output registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        clock <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
        clock <= cnt;
    end
end

endmodule