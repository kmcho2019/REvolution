module traffic_light (
    input  logic             rst_n,    // Reset signal (active low)
    input  logic             clk,      // Clock signal
    input  logic             pass_request, // Request signal for allowing vehicles to pass

    output logic [7:0]        clock,    // An 8-bit output representing the count value of the internal counter
    output logic             red,      // Output signal representing the state of the red traffic light
    output logic             yellow,   // Output signal representing the state of the yellow traffic light
    output logic             green     // Output signal representing the state of the green traffic light
);

// Define the enumeration values for the different states
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the internal counter and the previous output values
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
                      else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red;
                        else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow;
                       else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
        p_red <= (state == s1_red) ? 1'b1 : 0;
        p_yellow <= (state == s2_yellow) ? 1'b1 : 0;
        p_green <= (state == s3_green) ? 1'b1 : 0;
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
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

// Assign the internal counter to the output clock
assign clock = cnt;

endmodule