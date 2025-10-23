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
localparam idle      = 2'd0;
localparam s1_red    = 2'd1;
localparam s2_yellow = 2'd2;
localparam s3_green  = 2'd3;

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// Next output registers (combinational)
reg n_red, n_yellow, n_green;

always @(*) begin
    // Default next outputs off
    n_red = 1'b0;
    n_yellow = 1'b0;
    n_green = 1'b0;

    case(state)
        idle: begin
            // all off in idle
            n_red = 1'b0;
            n_yellow = 1'b0;
            n_green = 1'b0;
        end
        s1_red: begin
            n_red = 1'b1;
            n_yellow = 1'b0;
            n_green = 1'b0;
        end
        s2_yellow: begin
            n_red = 1'b0;
            n_yellow = 1'b1;
            n_green = 1'b0;
        end
        s3_green: begin
            n_red = 1'b0;
            n_yellow = 1'b0;
            n_green = 1'b1;
        end
        default: begin
            n_red = 1'b0;
            n_yellow = 1'b0;
            n_green = 1'b0;
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
                // Immediately transition to s1_red
                state <= s1_red;
            end
            s1_red: begin
                if(cnt == 8'd0) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            s3_green: begin
                if(cnt == 8'd0) begin
                    state <= s2_yellow;
                end else begin
                    state <= s3_green;
                end
            end
            s2_yellow: begin
                if(cnt == 8'd0) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

// Counter logic with pass_request handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;  // default reset count
    end else begin
        // Detect transitions for resetting counter
        // Transition into s3_green sets counter to 60 unless shortened by pass_request
        // Transition into s1_red sets to 10
        // Transition into s2_yellow sets to 5

        // Identify transition edges of outputs (use p_red, p_yellow, p_green)
        if ((green == 1'b1) && (p_green == 1'b1)) begin
            // green light continuing
            if (pass_request && (cnt > 8'd10)) begin
                cnt <= 8'd10;
            end else if (cnt != 8'd0) begin
                cnt <= cnt - 8'd1;
            end
        end else if ((green == 1'b1) && (p_green == 1'b0)) begin
            // green just turned on
            cnt <= 8'd60;
        end else if ((yellow == 1'b1) && (p_yellow == 1'b1)) begin
            // yellow continuing
            if (cnt != 8'd0)
                cnt <= cnt - 8'd1;
        end else if ((yellow == 1'b1) && (p_yellow == 1'b0)) begin
            // yellow just turned on
            cnt <= 8'd5;
        end else if ((red == 1'b1) && (p_red == 1'b1)) begin
            // red continuing
            if (cnt != 8'd0)
                cnt <= cnt - 8'd1;
        end else if ((red == 1'b1) && (p_red == 1'b0)) begin
            // red just turned on
            cnt <= 8'd10;
        end else if ((red == 1'b0) && (p_red == 1'b1)) begin
            // red just turned off, keep counting down if needed (shouldn't happen here)
            if (cnt != 8'd0)
                cnt <= cnt - 8'd1;
        end else begin
            // Default count down if none of above
            if (cnt != 8'd0)
                cnt <= cnt - 8'd1;
        end
    end
end

// Assign internal counter to output
assign clock = cnt;

// Output registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        red <= n_red;
        yellow <= n_yellow;
        green <= n_green;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

endmodule