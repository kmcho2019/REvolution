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

// Binary state encoding
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] state;
reg [5:0] cnt;  // 6 bits sufficient for max count of 60

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request during green
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN))
            cnt <= MIN_GREEN;
        // Normal countdown and state transition
        else if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Continuous output assignments
assign clock = {2'b00, cnt};  // Zero-extend to 8 bits
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule