module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

// State encoding
localparam [1:0]
    RED    = 2'b00,
    GREEN  = 2'b01,
    YELLOW = 2'b10;

// Timing parameters
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;

// State and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        if (timer == 0) begin
            // Transition state and reload timer on state expiration
            case (state)
                RED: begin
                    state <= GREEN;
                    timer <= GREEN_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    timer <= RED_TIME;
                end
                default: begin
                    state <= RED;
                    timer <= RED_TIME;
                end
            endcase
        end else begin
            // Timer running: handle pass_request during GREEN
            if ((state == GREEN) && pass_request && (timer > SHORT_GREEN)) begin
                timer <= SHORT_GREEN;
            end else begin
                timer <= timer - 1;
            end
        end
    end
end

// Outputs driven combinationally from current state
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = timer;

endmodule