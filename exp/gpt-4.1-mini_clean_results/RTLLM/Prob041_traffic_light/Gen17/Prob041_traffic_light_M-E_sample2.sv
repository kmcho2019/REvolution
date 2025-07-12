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
localparam [1:0] 
    IDLE    = 2'd0,  // Not used for actual state transitions, reserved
    RED     = 2'd1,
    YELLOW  = 2'd2,
    GREEN   = 2'd3;

// Timing parameters
localparam [7:0] RED_TIME    = 8'd10;
localparam [7:0] YELLOW_TIME = 8'd5;
localparam [7:0] GREEN_TIME  = 8'd60;
localparam [7:0] SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] counter, next_counter;

// Next state logic combinational
always @(*) begin
    next_state = state;
    next_counter = counter;

    case(state)
        RED: begin
            if (counter == 0) begin
                next_state = GREEN;
                next_counter = GREEN_TIME;
            end
        end
        GREEN: begin
            if (counter == 0) begin
                next_state = YELLOW;
                next_counter = YELLOW_TIME;
            end else if (pass_request && (counter > SHORT_GREEN)) begin
                // Pedestrian request shortens green time to 10 if more than 10 left
                next_counter = SHORT_GREEN;
            end else begin
                next_counter = counter - 1;
            end
        end
        YELLOW: begin
            if (counter == 0) begin
                next_state = RED;
                next_counter = RED_TIME;
            end
        end
        default: begin
            next_state = RED;
            next_counter = RED_TIME;
        end
    endcase
end

// State and counter update synchronous process
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= RED;
        counter <= RED_TIME;
    end else begin
        state   <= next_state;
        counter <= next_counter;
    end
end

// Output registers updated synchronously to state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        red    <= (state == RED);
        yellow <= (state == YELLOW);
        green  <= (state == GREEN);
        clock  <= counter;
    end
end

endmodule