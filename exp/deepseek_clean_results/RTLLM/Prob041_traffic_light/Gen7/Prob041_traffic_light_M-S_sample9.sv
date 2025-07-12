module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// States
localparam RED = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN = 2'b10;

reg [1:0] state;
reg [7:0] cnt;

// State and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 10;
    end else begin
        // Handle pedestrian request
        if (pass_request && state == GREEN && cnt > 10)
            cnt <= 10;
        // Normal countdown and state transition
        else if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= 60;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= 10;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= 5;
                end
            endcase
        end else
            cnt <= cnt - 1;
    end
end

// Output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule