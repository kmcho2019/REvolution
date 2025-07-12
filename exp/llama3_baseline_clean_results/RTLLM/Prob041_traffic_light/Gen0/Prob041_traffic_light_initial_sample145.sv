module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Define the registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// First always block: state transition logic
always @(*) begin
    case (state)
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

// Second always block: counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        state <= idle;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) cnt <= 60;
                else cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (cnt == 0) cnt <= 5;
                else if (pass_request && cnt > 10) cnt <= 10;
                else cnt <= cnt - 1;
            end
            default: cnt <= cnt;
        endcase
    end
end

// Third always block: output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        state <= idle;
    end else begin
        p_red <= (state == s1_red) ? 1 : 0;
        p_yellow <= (state == s2_yellow) ? 1 : 0;
        p_green <= (state == s3_green) ? 1 : 0;
        state <= next_state;
    end
end

// Assign statement: assign the value of the internal counter to the output clock
assign clock = cnt;
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule