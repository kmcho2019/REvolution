module traffic_light(
    input           rst_n,
    input           clk,
    input           pass_request,
    output [7:0]    clock,
    output          red,
    output          yellow,
    output          green
);

// Define the states of the traffic light controller
enum {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the internal counter
reg [7:0] cnt;

// Define the previous values of the output signals
reg p_red, p_yellow, p_green;

// Define the next values of the output signals
reg n_red, n_yellow, n_green;

// First always block: state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        p_red <= n_red;
        p_yellow <= n_yellow;
        p_green <= n_green;
    end
end

// Second always block: counting logic of the internal counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
                next_state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state <= s3_green;
                end else begin
                    cnt <= cnt - 1;
                    next_state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state <= s1_red;
                end else begin
                    cnt <= cnt - 1;
                    next_state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    next_state <= s2_yellow;
                end else if (pass_request && cnt > 10) begin
                    cnt <= 10;
                    next_state <= s3_green;
                end else begin
                    cnt <= cnt - 1;
                    next_state <= s3_green;
                end
            end
            default: begin
                next_state <= idle;
            end
        endcase
    end
end

// Assign the internal counter value to the output clock
assign clock = cnt;

// Assign the output signals based on the current state
always @(posedge clk or negedge rst_n) begin
    case (state)
        idle: begin
            n_red <= 0;
            n_yellow <= 0;
            n_green <= 0;
        end
        s1_red: begin
            n_red <= 1;
            n_yellow <= 0;
            n_green <= 0;
        end
        s2_yellow: begin
            n_red <= 0;
            n_yellow <= 1;
            n_green <= 0;
        end
        s3_green: begin
            n_red <= 0;
            n_yellow <= 0;
            n_green <= 1;
        end
        default: begin
            n_red <= 0;
            n_yellow <= 0;
            n_green <= 0;
        end
    endcase
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule