module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Parameters for different states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Registers and wires
logic [1:0] state;
logic [1:0] next_state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (state == s3_green && pass_request && cnt > 10) begin
            cnt <= 10;
        end else if (state != s3_green && p_green) begin
            cnt <= 60;
        end else if (state != s2_yellow && p_yellow) begin
            cnt <= 5;
        end else if (state != s1_red && p_red) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) cnt <= cnt - 1;
        end
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Output signal logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
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

// Assign statement for output clock
assign clock = cnt;

endmodule