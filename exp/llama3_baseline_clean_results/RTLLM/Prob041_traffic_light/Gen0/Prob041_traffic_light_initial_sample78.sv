module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Declare the internal counter and state register
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// First always block: State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
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

// Second always block: Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) cnt <= cnt - 1;
        end
    end
end

// Assign previous values to output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
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
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

// Assign internal counter value to output clock
assign clock = cnt;

endmodule