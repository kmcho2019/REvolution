module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define enumeration values for different states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define 1-bit registers for next values of output signals
logic p_red, p_yellow, p_green;

// Define 8-bit register for internal counter
logic [7:0] cnt;

// First always block: State transition logic
always_comb begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Second always block: Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
        p_red <= 1'b1;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
        state <= idle;
    end else begin
        case (state)
            s1_red: begin
                if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) begin
                    cnt <= 8'd60;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end
            end
            s2_yellow: begin
                if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) begin
                    cnt <= 8'd10;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            end
            s3_green: begin
                if (pass_request && cnt > 10) cnt <= 8'd10;
                else if (cnt > 0) cnt <= cnt - 1;
                if (cnt == 0) begin
                    cnt <= 8'd5;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end
            end
            default: cnt <= 8'd10;
        endcase
        state <= next_state;
    end
end

// Assign statement: Assign internal counter value to output clock
assign clock = cnt;

// Third always block: Output signal assignments
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

endmodule