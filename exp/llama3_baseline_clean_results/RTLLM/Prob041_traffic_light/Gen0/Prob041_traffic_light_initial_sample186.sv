module traffic_light(
    input  logic            rst_n,      // Reset signal (active low)
    input  logic            clk,       // Clock signal
    input  logic            pass_request, // Request signal for allowing vehicles to pass
    output logic [7:0]      clock,      // An 8-bit output representing the count value of the internal counter
    output logic            red,       // Output signal representing the red light
    output logic            yellow,    // Output signal representing the yellow light
    output logic            green      // Output signal representing the green light
);

// Define enumeration values for different states
enum logic [1:0] {idle, s1_red, s2_yellow, s3_green} state, next_state;

// Define internal counter and output signal registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            idle: cnt <= 10;
            s1_red: cnt <= (cnt == 0) ? 10 : cnt - 1;
            s2_yellow: cnt <= (cnt == 0) ? 5 : cnt - 1;
            s3_green: cnt <= (cnt == 0) ? 60 : cnt - 1;
            default: cnt <= cnt;
        endcase
        
        if (pass_request && green) begin
            if (cnt > 10) begin
                cnt <= 10;
            end
        end
    end
end

// Output signals
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

assign clock = cnt;

endmodule