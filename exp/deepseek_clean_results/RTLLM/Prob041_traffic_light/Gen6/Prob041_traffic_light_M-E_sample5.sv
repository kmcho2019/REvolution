module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Gray-coded state encoding
parameter [1:0] RED_ST    = 2'b00;
parameter [1:0] YELLOW_ST = 2'b01;
parameter [1:0] GREEN_ST  = 2'b11;

reg [1:0] state;
reg [5:0] timer;
reg ped_request_latched;
reg watchdog;

// Output assignments
assign clock = timer;

// Pedestrian request synchronization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ped_request_latched <= 1'b0;
    end else begin
        ped_request_latched <= pass_request;
    end
end

// Watchdog timer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        watchdog <= 1'b0;
    end else if (timer == 6'd0) begin
        watchdog <= 1'b1;
    end
end

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_ST;
        timer <= 6'd10;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Default outputs
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;

        case (state)
            RED_ST: begin
                red <= 1'b1;
                if (timer == 6'd1) begin
                    state <= GREEN_ST;
                    timer <= 6'd60;
                end else begin
                    timer <= timer - 6'd1;
                end
            end

            YELLOW_ST: begin
                yellow <= 1'b1;
                if (timer == 6'd1 || watchdog) begin
                    state <= RED_ST;
                    timer <= 6'd10;
                    watchdog <= 1'b0;
                end else begin
                    timer <= timer - 6'd1;
                end
            end

            GREEN_ST: begin
                green <= 1'b1;
                // Handle pedestrian request
                if (ped_request_latched && timer > 6'd10) begin
                    timer <= 6'd10;
                end
                
                if (timer == 6'd1 || watchdog) begin
                    state <= YELLOW_ST;
                    timer <= 6'd5;
                    watchdog <= 1'b0;
                end else begin
                    timer <= timer - 6'd1;
                end
            end

            default: begin  // Fault recovery
                state <= RED_ST;
                timer <= 6'd10;
            end
        endcase
    end
end

endmodule