module traffic_light(
    input               rst_n,
    input               clk,
    input               pass_request,
    output reg [7:0]    clock,
    output reg          red,
    output reg          yellow,
    output reg          green
);

// Define enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define 1-bit registers for next values of output signals
reg p_red, p_yellow, p_green;

// Define an 8-bit register for internal counter
reg [7:0] cnt;

// First always block for state transition logic
always @(*) begin
    case(state)
        idle: next_state = s1_red;
        s1_red: if(cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if(cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if(cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 10;
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end
    else begin
        // Update state
        state <= next_state;
        
        // Update counter
        if(pass_request && p_green) begin
            cnt <= 10;
        end
        else if(!p_green && p_green!= green) begin
            cnt <= 60;
        end
        else if(!p_yellow && p_yellow!= yellow) begin
            cnt <= 5;
        end
        else if(!p_red && p_red!= red) begin
            cnt <= 10;
        end
        else begin
            cnt <= cnt - 1;
        end
        
        // Update previous values of output signals
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Assign statement for output clock
assign clock = cnt;

// Final always block for output signals
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end
    else begin
        case(state)
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
end

endmodule