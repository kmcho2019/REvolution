module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the states of the traffic light controller
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Internal counter
reg [7:0] cnt;

// Current state of the traffic light controller
reg [1:0] state;

// Previous values of the output signals
reg p_red, p_yellow, p_green;

// Output signals
reg o_red, o_yellow, o_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green != o_green) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow != o_yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red != o_red) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
        p_red <= o_red;
        p_yellow <= o_yellow;
        p_green <= o_green;
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_red <= 1'b0;
        o_yellow <= 1'b0;
        o_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                o_red <= 1'b0;
                o_yellow <= 1'b0;
                o_green <= 1'b0;
            end
            s1_red: begin
                o_red <= 1'b1;
                o_yellow <= 1'b0;
                o_green <= 1'b0;
            end
            s2_yellow: begin
                o_red <= 1'b0;
                o_yellow <= 1'b1;
                o_green <= 1'b0;
            end
            s3_green: begin
                o_red <= 1'b0;
                o_yellow <= 1'b0;
                o_green <= 1'b1;
            end
            default: begin
                o_red <= 1'b0;
                o_yellow <= 1'b0;
                o_green <= 1'b0;
            end
        endcase
    end
end

assign clock = cnt;
assign red = o_red;
assign yellow = o_yellow;
assign green = o_green;

endmodule