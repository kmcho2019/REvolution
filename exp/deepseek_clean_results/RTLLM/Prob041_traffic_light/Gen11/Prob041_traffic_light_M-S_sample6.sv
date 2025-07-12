module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Binary state encoding
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 10; // RED_TIME
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > 10))
            cnt <= 10;
        
        // State transition and counter update
        if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= 60; // GREEN_TIME
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= 10; // RED_TIME
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= 5; // YELLOW_TIME
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Combined output assignments
assign {clock, red, yellow, green} = {cnt, state == RED, state == YELLOW, state == GREEN};

endmodule