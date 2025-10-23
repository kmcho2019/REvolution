module traffic_light(
    input  logic rst_n, 
    input  logic clk, 
    input  logic pass_request, 
    output logic [7:0] clock, 
    output logic red, 
    output logic yellow, 
    output logic green
);

    // Define the states
    enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

    // Internal registers
    logic [7:0] cnt;
    logic p_red, p_yellow, p_green;

    // State transition logic
    always_comb begin
        case(state)
            idle: next_state = s1_red;
            s1_red: if (cnt == 0) next_state = s3_green;
                      else next_state = s1_red;
            s2_yellow: if (cnt == 0) next_state = s1_red;
                        else next_state = s2_yellow;
            s3_green: if (cnt == 0) next_state = s2_yellow;
                       else next_state = s3_green;
            default: next_state = idle;
        endcase
    end

    // Counting logic
    always_comb begin
        if (!rst_n) 
            cnt = 10;
        else if (pass_request && p_green && p_green > 10) 
            cnt = 10;
        else if (!p_green && p_green > 0) 
            cnt = 60;
        else if (!p_yellow && p_yellow > 0) 
            cnt = 5;
        else if (!p_red && p_red > 0) 
            cnt = 10;
        else 
            cnt = cnt - 1;
    end

    // State and counter updates
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;
            if (pass_request && p_green && cnt > 10) 
                cnt <= 10;
            if (p_green && cnt == 0) 
                cnt <= 60;
            if (p_yellow && cnt == 0) 
                cnt <= 5;
            if (p_red && cnt == 0) 
                cnt <= 10;
            else 
                cnt <= cnt - 1;
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

    // Output signals
    assign clock = cnt;
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule