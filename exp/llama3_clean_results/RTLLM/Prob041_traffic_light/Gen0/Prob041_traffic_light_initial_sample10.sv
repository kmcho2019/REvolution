module traffic_light(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input pass_request,  // Request signal for allowing vehicles to pass
    output [7:0] clock,  // 8-bit output representing the count value of the internal counter
    output red,  // Output signal representing the state of the red traffic light
    output yellow,  // Output signal representing the state of the yellow traffic light
    output green  // Output signal representing the state of the green traffic light
);

// Define enumeration values for different states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define registers and wires
reg [7:0] cnt;  // 8-bit register used as an internal counter for timing purposes
reg [1:0] state;  // 2-bit register representing the current state of the traffic light controller
reg p_red, p_yellow, p_green;  // 1-bit registers representing the next values for the red, yellow, and green signals

// First always block: State transition logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= idle;
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
    if (~rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (~p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (~p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (~p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) cnt <= cnt - 1;
            else cnt <= cnt;
        end
    end
end

// Assign statement: Assign internal counter value to output clock
assign clock = cnt;

// Third always block: Output signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 1;
            end
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
        endcase
    end
end

// Continuous assignment: Assign previous signal values to output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule