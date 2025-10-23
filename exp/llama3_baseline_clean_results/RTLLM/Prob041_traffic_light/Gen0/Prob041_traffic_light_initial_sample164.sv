module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define registers for next values of output signals
logic p_red, p_yellow, p_green;

// Define register for internal counter
logic [7:0] cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
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
            end else if (pass_request && cnt > 10) begin
                next_state = s3_green;
            end else begin
                next_state = s3_green;
            end
        end
    endcase
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt != 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 10;
                end
            end
            s2_yellow: begin
                if (cnt != 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 5;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt != 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 60;
                end
            end
        endcase
    end
end

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
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
        endcase
    end
end

// Assign previous values to output signals
always @(posedge clk or negedge rst_n) begin
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