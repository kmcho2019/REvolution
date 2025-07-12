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
parameter G_TIME = 60;
parameter Y_TIME = 5;
parameter R_TIME = 10;
parameter MIN_G = 10;

// Binary state encoding
reg [1:0] state;
reg [7:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// State transition and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= R_TIME;
    end else begin
        if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= G_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= R_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= Y_TIME;
                end
            endcase
        end else begin
            // Handle pedestrian request
            if (pass_request && (state == GREEN) && (cnt > MIN_G))
                cnt <= MIN_G;
            else
                cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule