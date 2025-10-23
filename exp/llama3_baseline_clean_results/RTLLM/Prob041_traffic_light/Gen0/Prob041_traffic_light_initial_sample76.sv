module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Define enumeration values for states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Declare registers
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// First always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end
    else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= idle;
        endcase
    end
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt <= 8'd10;
    else if (pass_request && p_green) cnt <= 8'd10;
    else if (!p_green && p_green == 1'b1) cnt <= 8'd60;
    else if (!p_yellow && p_yellow == 1'b1) cnt <= 8'd5;
    else if (!p_red && p_red == 1'b1) cnt <= 8'd10;
    else cnt <= cnt - 1;
end

// Assign statement for output clock
assign clock = cnt;

// Final always block for output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else begin
        case (state)
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

endmodule