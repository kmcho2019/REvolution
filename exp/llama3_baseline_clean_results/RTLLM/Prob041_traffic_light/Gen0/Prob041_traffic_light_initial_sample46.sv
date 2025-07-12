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
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Registers and Wires
logic [7:0] cnt;
logic [1:0] state, next_state;
logic p_red, p_yellow, p_green;

// State Transition Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green; else next_state = s1_red;
        s2_yellow: if (cnt == 0) next_state = s1_red; else next_state = s2_yellow;
        s3_green: if (cnt == 0) next_state = s2_yellow; else next_state = s3_green;
        default: next_state = idle;
    endcase
end

// Counting Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red) begin
            if (cnt == 0) cnt <= 10;
            else cnt <= cnt - 1;
        end else if (state == s2_yellow) begin
            if (cnt == 0) cnt <= 5;
            else cnt <= cnt - 1;
        end else if (state == s3_green) begin
            if (pass_request && cnt > 10) cnt <= 10;
            else if (cnt == 0) cnt <= 60;
            else cnt <= cnt - 1;
        end
    end
end

// Assign clock output
assign clock = cnt;

// Output Signals
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

always @(*) begin
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
end

endmodule