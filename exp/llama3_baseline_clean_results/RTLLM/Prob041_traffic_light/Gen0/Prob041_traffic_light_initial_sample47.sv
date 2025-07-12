module traffic_light(
    input         rst_n,
    input         clk,
    input         pass_request,
    output [7:0]  clock,
    output        red,
    output        yellow,
    output        green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Declare the registers and wires
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
        s1_red: begin
            if (cnt == 0) next_state = s3_green;
            else next_state = s1_red;
        end
        s2_yellow: begin
            if (cnt == 0) next_state = s1_red;
            else next_state = s2_yellow;
        end
        s3_green: begin
            if (cnt == 0) next_state = s2_yellow;
            else next_state = s3_green;
        end
        default: next_state = idle;
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green && cnt > 10) begin
            cnt <= 10;
        end else if (!p_green && p_green!= green) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow!= yellow) begin
            cnt <= 5;
        end else if (!p_red && p_red!= red) begin
            cnt <= 10;
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Output signal handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
    end
end

// Assign the internal counter to the output clock
assign clock = cnt;

endmodule