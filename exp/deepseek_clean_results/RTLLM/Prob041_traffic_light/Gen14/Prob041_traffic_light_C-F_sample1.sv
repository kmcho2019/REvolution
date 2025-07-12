module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
reg [1:0] state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            RED: begin
                if (cnt == 1) begin
                    state <= GREEN;
                    red <= 1'b0;
                    green <= 1'b1;
                end
            end
            YELLOW: begin
                if (cnt == 1) begin
                    state <= RED;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end
            end
            GREEN: begin
                if (cnt == 1) begin
                    state <= YELLOW;
                    green <= 1'b0;
                    yellow <= 1'b1;
                end
            end
        endcase
    end
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 1) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule