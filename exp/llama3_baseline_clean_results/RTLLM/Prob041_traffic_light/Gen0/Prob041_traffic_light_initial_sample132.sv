module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define parameters for states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define registers and wires
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;
reg [7:0] next_cnt;

// Always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end
    else begin
        case (state)
            idle: begin
                state <= s1_red;
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
                else begin
                    state <= s1_red;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
                else begin
                    state <= s2_yellow;
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
                else if (pass_request && p_green) begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
                else begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
            end
        endcase
    end
end

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end
    else begin
        case (state)
            idle: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 5;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    if (pass_request) begin
                        cnt <= 10;
                    end
                    else begin
                        cnt <= 60;
                    end
                end
                else if (pass_request && p_green && cnt > 10) begin
                    cnt <= 10;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Assign statement for output clock
assign clock = cnt;

// Always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end
    else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule