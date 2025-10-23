module traffic_light(
    input  logic         rst_n, // Reset signal (active low)
    input  logic         clk,  // Clock signal
    input  logic         pass_request, // Request signal for allowing vehicles to pass
    output logic [7:0]   clock, // An 8-bit output representing the count value of the internal counter
    output logic         red,   // Output signal representing the state of the red light
    output logic         yellow, // Output signal representing the state of the yellow light
    output logic         green  // Output signal representing the state of the green light
);

// Define enumeration values for different states of the traffic light controller
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define registers for internal counter and output signals
logic [7:0] cnt;
logic         p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end else begin
                next_state = s1_red;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end else begin
                next_state = s2_yellow;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end else if (pass_request && cnt > 10) begin
                next_state = s3_green;
            end else begin
                next_state = s3_green;
            end
        end
        default: begin
            next_state = idle;
        end
    endcase
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else if (pass_request && green) begin
        cnt <= 8'd10;
    end else if (!green && p_green) begin
        cnt <= 8'd60;
    end else if (!yellow && p_yellow) begin
        cnt <= 8'd5;
    end else if (!red && p_red) begin
        cnt <= 8'd10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Assign output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Assign output signals based on current state
always_comb begin
    case (state)
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

// Assign internal counter value to output clock
assign clock = cnt;

endmodule