module traffic_light(
    input  logic        rst_n,      // Reset signal (active low)
    input  logic        clk,        // Clock signal
    input  logic        pass_request, // Request signal for allowing vehicles to pass
    output logic [7:0]  clock,      // An 8-bit output representing the count value of the internal counter
    output logic        red,        // Output signal representing the state of the red traffic light
    output logic        yellow,     // Output signal representing the state of the yellow traffic light
    output logic        green       // Output signal representing the state of the green traffic light
);

// Parameters for the different states of the traffic light controller
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Registers for the internal counter and state
logic [7:0] cnt;
logic [1:0] state;
logic p_red, p_yellow, p_green;

// First always block: State transition logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= idle;
        p_red <= 1'b0;
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
                if (cnt == 1) begin
                    state <= s3_green;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                end
            end
            s2_yellow: begin
                if (cnt == 1) begin
                    state <= s1_red;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                end
            end
            s3_green: begin
                if (cnt == 1) begin
                    state <= s2_yellow;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                end
            end
        endcase
    end
end

// Second always block: Counting logic of the internal counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 8'd10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 1) begin
                    cnt <= 8'd10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 1) begin
                    cnt <= 8'd5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (pass_request && p_green) begin
                    cnt <= 8'd10;
                end else if (cnt == 1) begin
                    cnt <= 8'd60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Assign statement: Assign the value of the internal counter to the output clock
assign clock = cnt;

// Third always block: Output signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
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