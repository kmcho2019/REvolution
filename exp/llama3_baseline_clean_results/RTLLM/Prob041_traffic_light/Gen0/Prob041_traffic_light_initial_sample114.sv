module traffic_light(
    input  logic            rst_n,
    input  logic            clk,
    input  logic            pass_request,
    output logic [7:0]       clock,
    output logic            red,
    output logic            yellow,
    output logic            green
);

// Enumerations for different states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Internal counter
logic [7:0] cnt;

// Previous values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 10;
    end else if (state == s1_red) begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (~p_red && red) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end else if (state == s2_yellow) begin
        if (~p_yellow && yellow) begin
            cnt <= 5;
        end else begin
            cnt <= cnt - 1;
        end
    end else if (state == s3_green) begin
        if (~p_green && green) begin
            cnt <= 60;
        end else if (pass_request && p_green) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end else begin
        cnt <= cnt;
    end
end

// Output signal logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Assign output signals based on the current state
always_comb begin
    case (state)
        idle: begin
            red = 0;
            yellow = 0;
            green = 0;
        end
        s1_red: begin
            red = 1;
            yellow = 0;
            green = 0;
        end
        s2_yellow: begin
            red = 0;
            yellow = 1;
            green = 0;
        end
        s3_green: begin
            red = 0;
            yellow = 0;
            green = 1;
        end
        default: begin
            red = 0;
            yellow = 0;
            green = 0;
        end
    endcase
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule