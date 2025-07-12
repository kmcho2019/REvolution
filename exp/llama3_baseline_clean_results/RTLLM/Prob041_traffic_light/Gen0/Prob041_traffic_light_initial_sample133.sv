module traffic_light(
    input  logic           rst_n,      // Reset signal (active low)
    input  logic           clk,       // Clock signal
    input  logic           pass_request, // Request signal for allowing vehicles to pass
    output logic [7:0]      clock,     // An 8-bit output representing the count value of the internal counter
    output logic           red,       // Output signal representing the red color of the traffic light
    output logic           yellow,    // Output signal representing the yellow color of the traffic light
    output logic           green      // Output signal representing the green color of the traffic light
);

// Define enumeration values for different states of the traffic light controller
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define registers for the internal counter and next state values
logic [7:0] cnt;
logic       p_red, p_yellow, p_green;

// First always block: State transition logic
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
                next_state = s2_yellow;
            end else begin
                next_state = s3_green;
            end
        end
        default: begin
            next_state = idle;
        end
    endcase
end

// Second always block: Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (state == s1_red && cnt == 0) begin
            cnt <= 10;
        end else if (state == s3_green && pass_request && cnt > 10) begin
            cnt <= 10;
        end else if (state == s2_yellow && cnt == 0) begin
            cnt <= 5;
        end else if (state == s3_green && cnt == 0) begin
            cnt <= 60;
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end else begin
            cnt <= cnt;
        end
    end
end

// Assign statement: Output count value
assign clock = cnt;

// Third always block: Output signal assignment
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= (state == s1_red);
        p_yellow <= (state == s2_yellow);
        p_green <= (state == s3_green);
    end
end

// Final assign statements: Output signals
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;

endmodule