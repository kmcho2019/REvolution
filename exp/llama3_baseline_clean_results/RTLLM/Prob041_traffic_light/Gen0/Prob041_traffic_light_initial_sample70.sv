module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define the enumeration values for different states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers for the internal counter and state
reg [7:0] cnt;
reg [1:0] state;

// Define the registers for the next values of the red, yellow, and green signals
reg p_red, p_yellow, p_green;

// Always block for state transition logic
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

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
        p_red <= (state == s1_red)? 1'b1 : 1'b0;
        p_yellow <= (state == s2_yellow)? 1'b1 : 1'b0;
        p_green <= (state == s3_green)? 1'b1 : 1'b0;
    end
end

// Assign statement for output clock
assign clock = cnt;

// Always block for output signal handling
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