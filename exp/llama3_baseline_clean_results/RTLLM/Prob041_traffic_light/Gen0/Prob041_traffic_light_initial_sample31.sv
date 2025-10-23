module traffic_light(
    input logic rst_n, 
    input logic clk, 
    input logic pass_request,
    output logic [7:0] clock,
    output logic red, 
    output logic yellow, 
    output logic green
);

    // Parameters
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Registers and wires
    logic [7:0] cnt;
    logic [1:0] state;
    logic p_red, p_yellow, p_green;

    // First always block: State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            p_red <= 1'b0;
            p_yellow <= 1'b0;
            p_green <= 1'b0;
        end else begin
            case (state)
                idle: state <= s1_red;
                s1_red: if (cnt == 1'b0) state <= s3_green; else state <= s1_red;
                s2_yellow: if (cnt == 1'b0) state <= s1_red; else state <= s2_yellow;
                s3_green: if (cnt == 1'b0) state <= s2_yellow; else state <= s3_green;
                default: state <= idle;
            endcase
            p_red <= (state == s1_red);
            p_yellow <= (state == s2_yellow);
            p_green <= (state == s3_green);
        end
    end

    // Second always block: Counting logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else if (pass_request && p_green) begin
            if (cnt > 8'd10) cnt <= 8'd10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 8'd60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 8'd5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 8'd10;
        end else begin
            if (cnt > 8'd0) cnt <= cnt - 8'd1;
            else cnt <= cnt;
        end
    end

    // Assign statement
    assign clock = cnt;

    // Final always block: Output signals
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