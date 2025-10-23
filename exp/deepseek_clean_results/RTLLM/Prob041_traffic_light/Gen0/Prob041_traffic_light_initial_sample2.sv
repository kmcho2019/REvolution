module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: next_state = (cnt == 8'd1) ? s3_green : s1_red;
        s2_yellow: next_state = (cnt == 8'd1) ? s1_red : s2_yellow;
        s3_green: next_state = (cnt == 8'd1) ? s2_yellow : s3_green;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        // Store previous output values
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        
        // Handle counter updates
        case (state)
            idle: begin
                cnt <= 8'd10;
            end
            s1_red: begin
                if (cnt == 8'd1) begin
                    cnt <= 8'd60;  // Next state is green
                end else begin
                    cnt <= cnt - 8'd1;
                end
            end
            s2_yellow: begin
                if (cnt == 8'd1) begin
                    cnt <= 8'd10;  // Next state is red
                end else begin
                    cnt <= cnt - 8'd1;
                end
            end
            s3_green: begin
                if (pass_request && green && (cnt > 8'd10)) begin
                    cnt <= 8'd10;  // Shorten green time if requested
                end else if (cnt == 8'd1) begin
                    cnt <= 8'd5;   // Next state is yellow
                end else begin
                    cnt <= cnt - 8'd1;
                end
            end
            default: begin
                cnt <= 8'd10;
            end
        endcase
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        clock <= cnt;
        case (state)
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

endmodule