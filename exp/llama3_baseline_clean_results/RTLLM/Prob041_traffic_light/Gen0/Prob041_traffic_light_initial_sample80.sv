module traffic_light(
    input  logic            rst_n,
    input  logic            clk,
    input  logic            pass_request,
    output logic [7:0]      clock,
    output logic            red,
    output logic            yellow,
    output logic            green
);

// Define enum for states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end else begin
                next_state = s1_red;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end else begin
                next_state = s2_yellow;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end else begin
                next_state = s3_green;
            end
        end
        default: next_state = idle;
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
                state <= next_state;
            end
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
                state <= next_state;
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
                state <= next_state;
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt == 0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
                state <= next_state;
            end
            default: begin
                cnt <= cnt;
                state <= state;
            end
        endcase
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
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

// Assign internal counter to output clock
assign clock = cnt;

endmodule