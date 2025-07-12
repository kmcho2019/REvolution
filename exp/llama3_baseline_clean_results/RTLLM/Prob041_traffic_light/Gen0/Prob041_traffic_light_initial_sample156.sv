module traffic_light (
    input  logic        rst_n, 
    input  logic        clk, 
    input  logic        pass_request,
    output logic [7:0]  clock, 
    output logic        red, 
    output logic        yellow, 
    output logic        green
);

// Define the states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define the registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: state <= (cnt == 0) ? s3_green : s1_red;
            s2_yellow: state <= (cnt == 0) ? s1_red : s2_yellow;
            s3_green: state <= (cnt == 0) ? s2_yellow : s3_green;
            default: state <= idle;
        endcase
        p_red <= (state == s1_red) ? 1'b1 : 1'b0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 1'b0;
        p_green <= (state == s3_green) ? 1'b1 : 1'b0;
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
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
            cnt <= cnt - 1;
        end
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule