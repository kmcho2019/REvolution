module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Parameters for states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Registers for internal counter and previous signal values
logic [7:0] cnt;
logic [1:0] state;
logic p_red, p_yellow, p_green;

// First always block: State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Second always block: Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: if (cnt > 0) cnt <= cnt - 1; else cnt <= 10;
            s2_yellow: if (cnt > 0) cnt <= cnt - 1; else cnt <= 5;
            s3_green: if (pass_request && p_green) cnt <= 10; else if (cnt > 0) cnt <= cnt - 1; else cnt <= 60;
            default: cnt <= 10;
        endcase
    end
end

// Assign statement: Assign internal counter to output clock
assign clock = cnt;

// Final always block: Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            s1_red: red <= 1; yellow <= 0; green <= 0;
            s2_yellow: red <= 0; yellow <= 1; green <= 0;
            s3_green: red <= 0; yellow <= 0; green <= 1;
            default: red <= 0; yellow <= 0; green <= 0;
        endcase
    end
end

endmodule