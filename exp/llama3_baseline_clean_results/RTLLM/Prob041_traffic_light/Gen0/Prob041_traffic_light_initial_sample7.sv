module traffic_light(
    input               rst_n,
    input               clk,
    input               pass_request,
    output reg [7:0]    clock,
    output reg           red,
    output reg           yellow,
    output reg           green
);

    // Define the states
    localparam idle = 2'b00;
    localparam s1_red = 2'b01;
    localparam s2_yellow = 2'b10;
    localparam s3_green = 2'b11;

    // Declare the state register
    reg [1:0] state;
    reg [1:0] next_state;

    // Declare the counter register
    reg [7:0] cnt;

    // Declare the previous values of the output signals
    reg p_red;
    reg p_yellow;
    reg p_green;

    // State transition logic
    always @(*) begin
        case(state)
            idle: next_state = s1_red;
            s1_red: if(cnt == 0) next_state = s3_green; else next_state = s1_red;
            s2_yellow: if(cnt == 0) next_state = s1_red; else next_state = s2_yellow;
            s3_green: if(cnt == 0) next_state = s2_yellow; else next_state = s3_green;
            default: next_state = idle;
        endcase
    end

    // Counting logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            state <= next_state;
            if(pass_request && p_green) cnt <= 10;
            else if(!p_green && p_green == 1) cnt <= 60;
            else if(!p_yellow && p_yellow == 1) cnt <= 5;
            else if(!p_red && p_red == 1) cnt <= 10;
            else if(cnt > 0) cnt <= cnt - 1;
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

    // Output signals
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= (state == s1_red) ? 1 : 0;
            yellow <= (state == s2_yellow) ? 1 : 0;
            green <= (state == s3_green) ? 1 : 0;
        end
    end

    assign clock = cnt;

endmodule