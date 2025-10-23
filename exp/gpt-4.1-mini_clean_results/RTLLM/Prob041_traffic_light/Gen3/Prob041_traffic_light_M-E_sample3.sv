module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam IDLE      = 2'd0;
localparam S1_RED    = 2'd1;
localparam S2_YELLOW = 2'd2;
localparam S3_GREEN  = 2'd3;

// State durations (clock cycles)
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam GREEN_MIN   = 8'd10;

reg [1:0] state, next_state;
reg [7:0] counter;
reg pass_req_sync_0, pass_req_sync_1; // synchronize pass_request

// Synchronize pass_request to clk domain to avoid metastability
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_req_sync_0 <= 1'b0;
        pass_req_sync_1 <= 1'b0;
    end else begin
        pass_req_sync_0 <= pass_request;
        pass_req_sync_1 <= pass_req_sync_0;
    end
end

wire pass_req = pass_req_sync_1;

// State register and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= IDLE;
        counter <= 8'd0;
    end else begin
        state <= next_state;

        if (state == next_state) begin
            // Same state: count down if counter > 0
            if (counter > 0)
                counter <= counter - 1;
            else
                counter <= 0;
        end else begin
            // On state change, load counter with state's duration
            case (next_state)
                IDLE:    counter <= 8'd0;
                S1_RED:  counter <= RED_TIME;
                S2_YELLOW:counter <= YELLOW_TIME;
                S3_GREEN: counter <= GREEN_TIME;
                default: counter <= 8'd0;
            endcase
        end

        // Pedestrian request shortening logic (only in green state)
        if (state == S3_GREEN && pass_req) begin
            // Shorten green if counter > GREEN_MIN
            if (counter > GREEN_MIN)
                counter <= GREEN_MIN;
        end
    end
end

// Next state logic based on counter hitting zero
always @(*) begin
    next_state = state;
    case(state)
        IDLE: 
            // Immediately move to red after reset
            next_state = S1_RED;
        S1_RED:
            if (counter == 0)
                next_state = S3_GREEN;
        S3_GREEN:
            if (counter == 0)
                next_state = S2_YELLOW;
        S2_YELLOW:
            if (counter == 0)
                next_state = S1_RED;
        default:
            next_state = IDLE;
    endcase
end

// Output logic: registered outputs updated on clock edge for glitch-free signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        case(state)
            IDLE: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            S1_RED: begin
                red    <= 1'b1;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            S2_YELLOW: begin
                red    <= 1'b0;
                yellow <= 1'b1;
                green  <= 1'b0;
            end
            S3_GREEN: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b1;
            end
            default: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
        endcase
        clock <= counter;
    end
end

endmodule