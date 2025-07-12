module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [7:0] cnt;
reg [1:0] state, next_state;
reg p_red, p_yellow, p_green;
reg clk_enable;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        red <= 0;
        yellow <= 0;
        green <= 0;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        clk_enable <= 1;
    end else begin
        state <= next_state;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        if (pass_request && green && cnt > 10) begin
            cnt <= 10;
        end else if (cnt == 0) begin
            case (state)
                s1_red: cnt <= 10;
                s2_yellow: cnt <= 5;
                s3_green: cnt <= 60;
                default: cnt <= 10;
            endcase
        end else if (clk_enable && cnt > 0) begin
            cnt <= cnt - 1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Clock gating logic
always @(*) begin
    case (state)
        s1_red: clk_enable = (cnt > 0);
        s2_yellow: clk_enable = (cnt > 0);
        s3_green: clk_enable = (cnt > 0);
        default: clk_enable = 1;
    endcase
end

// Output signal assignments
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
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

// Assign the output clock
assign clock = cnt;

endmodule