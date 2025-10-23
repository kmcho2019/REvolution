module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// One-hot state encoding
reg [2:0] state;
reg [5:0] cnt;
reg pass_request_sync;

// State definitions
localparam RED    = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b100;

// Synchronize pass_request to avoid metastability
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pass_request_sync <= 0;
    else pass_request_sync <= pass_request;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // State transition and counter logic
        case (1'b1) // synthesis parallel_case
            state[0]: begin // RED
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            state[1]: begin // YELLOW
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            state[2]: begin // GREEN
                // Handle pedestrian request only once per green cycle
                if (pass_request_sync && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end else if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin // Fault recovery
                state <= RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Output assignments with clock gating hint
assign clock = cnt;
assign red = state[0];
assign yellow = state[1];
assign green = state[2];

// synthesis translate_off
// Clock gating hint for synthesis
reg gated_clock;
always @* begin
    gated_clock = clk & (|cnt); // Gate clock when counter is zero
end
// synthesis translate_on

endmodule