module traffic_light(
    input  logic       rst_n,       // Reset signal (active low)
    input  logic       clk,         // Clock signal
    input  logic       pass_request,// Request signal for allowing vehicles to pass
    output logic [7:0] clock,       // An 8-bit output representing the count value of the internal counter
    output logic       red,         // Output signal representing the state of the red light
    output logic       yellow,      // Output signal representing the state of the yellow light
    output logic       green        // Output signal representing the state of the green light
);

// Parameters representing different states of the traffic light controller
parameter idle    = 2'b00,
           s1_red = 2'b01,
           s2_yellow = 2'b10,
           s3_green = 2'b11;

// 8-bit register used as an internal counter for timing purposes
logic [7:0] cnt;

// 2-bit register representing the current state of the traffic light controller
logic [1:0] state;

// 1-bit registers representing the next values for the red, yellow, and green signals
logic p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b1;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end else begin
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end else begin
                    state <= s2_yellow;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end else if (pass_request && p_green) begin
                    cnt <= 10;
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end else begin
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end
            end
            default: begin
                state <= idle;
                p_red <= 1'b1;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
            end
        endcase
    end
end

// Counting logic of the internal counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            idle: begin
                cnt <= 10;
            end
            s1_red: begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 10;
                end
            end
            s2_yellow: begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 5;
                end
            end
            s3_green: begin
                if (pass_request && p_green && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end else begin
                    cnt <= 60;
                end
            end
            default: begin
                cnt <= 10;
            end
        endcase
    end
end

// Assign statement assigns the value of the internal counter to the output clock
assign clock = cnt;

// Output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

endmodule