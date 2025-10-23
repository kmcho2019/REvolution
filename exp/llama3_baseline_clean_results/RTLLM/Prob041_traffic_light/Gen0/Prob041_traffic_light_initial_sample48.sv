module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the enumeration values for the states
typedef enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state_type;

// Declare the registers and wires
reg [1:0] state;
reg [7:0] cnt;
reg p_red, p_yellow, p_green;

// Always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: begin
                if (cnt == 0) state <= s3_green;
                else state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 0) state <= s1_red;
                else state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 0) state <= s2_yellow;
                else state <= s3_green;
            end
            default: state <= idle;
        endcase
    end
end

// Always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_green && p_green == 1) cnt <= 60;
                else if (!p_yellow && p_yellow == 1) cnt <= 5;
                else if (!p_red && p_red == 1) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s1_red: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_green && p_green == 1) cnt <= 10;
                else if (!p_yellow && p_yellow == 1) cnt <= 5;
                else if (!p_red && p_red == 1) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_green && p_green == 1) cnt <= 60;
                else if (!p_yellow && p_yellow == 1) cnt <= 5;
                else if (!p_red && p_red == 1) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_green && p_green == 1) cnt <= 60;
                else if (!p_yellow && p_yellow == 1) cnt <= 5;
                else if (!p_red && p_red == 1) cnt <= 10;
                else cnt <= cnt - 1;
            end
            default: cnt <= cnt - 1;
        endcase
    end
end

// Always block for output signal handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
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
            default: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
        endcase
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

// Assign statement for output clock
assign clock = cnt;

endmodule