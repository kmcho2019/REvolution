module traffic_light(
    input               rst_n,    // Reset signal (active low)
    input               clk,     // Clock signal
    input               pass_request, // Request signal for allowing vehicles to pass
    output  reg [7:0]    clock,  // An 8-bit output representing the count value of the internal counter
    output  reg         red,    // Output signal representing the state of the traffic lights
    output  reg         yellow, // Output signal representing the state of the traffic lights
    output  reg         green   // Output signal representing the state of the traffic lights
);

// Define the states of the traffic light controller
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Define the registers for the state and the internal counter
reg [1:0] state;
reg [7:0] cnt;
reg       p_red, p_yellow, p_green;

// First always block for state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                end else begin
                    state <= s1_red;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                end else begin
                    state <= s2_yellow;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                end else if (pass_request && cnt > 10) begin
                    state <= s2_yellow;
                end else begin
                    state <= s3_green;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

// Second always block for counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                p_red <= 0;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                if (cnt == 10) begin
                    cnt <= 10;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s2_yellow: begin
                if (cnt == 5) begin
                    cnt <= 5;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
                p_red <= 0;
                p_yellow <= 1;
                p_green <= 0;
            end
            s3_green: begin
                if (cnt == 60 && pass_request == 0) begin
                    cnt <= 60;
                end else if (cnt == 10 && pass_request == 1) begin
                    cnt <= 10;
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;
                end
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
end

// Assign statement for output clock
assign clock = cnt;

// Final always block for output signals
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

endmodule