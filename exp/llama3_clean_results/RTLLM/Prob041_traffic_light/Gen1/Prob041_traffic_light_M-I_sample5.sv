module traffic_light(
    input rst_n, clk, pass_request,
    output reg [7:0] clock,
    output reg red, yellow, green
);

// Define the states
localparam idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [1:0] state, next_state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// First always block: state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green;
                 else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red;
                    else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow;
                   else if (pass_request && cnt > 10) next_state = s2_yellow;
                   else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Second always block: counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red && cnt == 0) begin
            cnt <= 10;
        end else if (state == s2_yellow && cnt == 0) begin
            cnt <= 5;
        end else if (state == s3_green && cnt == 0) begin
            cnt <= 60;
        end else if (state == s3_green && pass_request && cnt > 10) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Assign output signals
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

// Output signals based on state
always @(*) begin
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

endmodule