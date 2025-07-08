module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State parameters
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Internal registers
reg [1:0] state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 8'd1) state <= s3_green;
                else state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 8'd1) state <= s1_red;
                else state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 8'd1) state <= s2_yellow;
                else state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 8'd1) cnt <= 8'd60;
                else cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 8'd1) cnt <= 8'd10;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && (cnt > 8'd10)) begin
                    cnt <= 8'd10;
                end else if (cnt == 8'd1) begin
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: cnt <= 8'd10;
        endcase
    end
end

// Output signal generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            s1_red: begin
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s2_yellow: begin
                p_red <= 1'b0;
                p_yellow <= 1'b1;
                p_green <= 1'b0;
            end
            s3_green: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b1;
            end
            default: begin
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
    end
end

// Assign outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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