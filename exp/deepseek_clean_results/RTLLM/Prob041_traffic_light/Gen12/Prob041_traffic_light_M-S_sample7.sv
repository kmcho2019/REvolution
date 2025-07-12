module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
parameter ST_RED    = 2'b00;
parameter ST_YELLOW = 2'b01;
parameter ST_GREEN  = 2'b10;

reg [1:0] state;
reg [7:0] counter;

// Continuous output assignments
assign red    = (state == ST_RED);
assign yellow = (state == ST_YELLOW);
assign green  = (state == ST_GREEN);
assign clock  = counter;

// Combined state and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_RED;
        counter <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request && green && (counter > MIN_GREEN)) begin
            counter <= MIN_GREEN;
        end
        // Counter and state transition logic
        if (counter == 0) begin
            case (state)
                ST_RED: begin
                    state <= ST_GREEN;
                    counter <= GREEN_TIME;
                end
                ST_YELLOW: begin
                    state <= ST_RED;
                    counter <= RED_TIME;
                end
                ST_GREEN: begin
                    state <= ST_YELLOW;
                    counter <= YELLOW_TIME;
                end
            endcase
        end else begin
            counter <= counter - 1;
        end
    end
end

endmodule