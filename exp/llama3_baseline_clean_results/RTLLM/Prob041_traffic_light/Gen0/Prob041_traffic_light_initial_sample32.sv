module traffic_light(
    input   logic       rst_n,
    input   logic       clk,
    input   logic       pass_request,
    output  logic [7:0] clock,
    output  logic       red,
    output  logic       yellow,
    output  logic       green
);

// Define the states of the traffic light controller
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the internal counter
logic [7:0] cnt;

// Define the previous values of the output signals
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                end else begin
                    state <= s3_green;
                end
            end
        endcase
    end
end

// Counting logic of the internal counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 0;
                end
            end
            s2_yellow: begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 0;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 0;
                end
            end
        endcase
    end
end

// Initialize the internal counter based on the current state
always_comb begin
    case (state)
        s1_red: begin
            if (cnt == 0) begin
                cnt = 10;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                cnt = 5;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                cnt = 60;
            end
        end
    endcase
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
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
        endcase
    end
end

endmodule