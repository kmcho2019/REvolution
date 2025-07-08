module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

// State encoding
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition and next state output signals logic
always @(*) begin
    // default next signals zero
    p_red    = 1'b0;
    p_yellow = 1'b0;
    p_green  = 1'b0;

    case(state)
        idle: begin
            // All off, transition immediately to s1_red
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
        s1_red: begin
            // Red on
            p_red    = 1'b1;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
        s2_yellow: begin
            // Yellow on
            p_red    = 1'b0;
            p_yellow = 1'b1;
            p_green  = 1'b0;
        end
        s3_green: begin
            // Green on
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b1;
        end
        default: begin
            p_red    = 1'b0;
            p_yellow = 1'b0;
            p_green  = 1'b0;
        end
    endcase
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case(state)
            idle: begin
                // Immediately go to s1_red
                state <= s1_red;
            end
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

// Counter logic with special conditions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10; // reset counter to 10
    end else begin
        // Default next count value
        if (state == idle) begin
            cnt <= 8'd10; // during idle we keep 10 for safety
        end else if (state == s3_green) begin
            // Green state with pass_request shortening green time if > 10
            if (pass_request && cnt > 8'd10) begin
                cnt <= 8'd10;
            end else if (cnt > 0) begin
                cnt <= cnt - 1;
            end else begin
                cnt <= cnt;
            end
        end else if (state == s2_yellow) begin
            // Yellow state countdown
            if (cnt == 0)
                cnt <= cnt;
            else
                cnt <= cnt - 1;
        end else if (state == s1_red) begin
            // Red state countdown
            if (cnt == 0)
                cnt <= cnt;
            else
                cnt <= cnt - 1;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Counter reload at state changes and special conditions
reg [1:0] state_d1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_d1 <= idle;
    end else begin
        state_d1 <= state;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        // When state changes, reload counter accordingly
        if (state != state_d1) begin
            case(state)
                s1_red:    cnt <= 8'd10;
                s2_yellow: cnt <= 8'd5;
                s3_green:  cnt <= 8'd60;
                default:   cnt <= 8'd10;
            endcase
        end else begin
            // counter handled in previous always block
            // but we need to prevent duplicate assignment, so no else here
        end
    end
end

// Update outputs on clock edge or reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
    end else begin
        red    <= p_red;
        yellow <= p_yellow;
        green  <= p_green;
    end
end

// Assign output clock
assign clock = cnt;

endmodule