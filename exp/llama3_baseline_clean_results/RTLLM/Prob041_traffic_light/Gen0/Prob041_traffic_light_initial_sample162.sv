module traffic_light(
    input  logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Enumerations for states
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Internal counter
logic [7:0] cnt;
// Previous output values
logic p_red, p_yellow, p_green;

// State transition logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end
    else begin
        case (state)
            s1_red: if (cnt > 0) cnt <= cnt - 1;
            s2_yellow: if (cnt > 0) cnt <= cnt - 1;
            s3_green: if (cnt > 0) cnt <= cnt - 1;
            default: cnt <= cnt;
        endcase
        
        if (pass_request && p_green) begin
            cnt <= 10;
        end
        else if (!p_green && p_green == 1) begin
            cnt <= 60;
        end
        else if (!p_yellow && p_yellow == 1) begin
            cnt <= 5;
        end
        else if (!p_red && p_red == 1) begin
            cnt <= 10;
        end
        
        state <= next_state;
        
        // Update previous output values
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end
    else begin
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

// Assign internal counter value to output clock
assign clock = cnt;

endmodule