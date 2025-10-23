module traffic_light(
    input logic rst_n, clk, pass_request,
    output logic [7:0] clock,
    output logic red, yellow, green
);

// Define states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Registers
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// First always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
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

// Update previous signal values
always @(posedge clk) begin
    case (state)
        idle: begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end
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

// Assign internal counter to output
assign clock = cnt;

endmodule