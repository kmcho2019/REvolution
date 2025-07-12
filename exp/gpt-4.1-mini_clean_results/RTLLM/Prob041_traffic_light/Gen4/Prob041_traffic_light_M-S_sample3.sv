module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam RED    = 2'd0;
localparam YELLOW = 2'd1;
localparam GREEN  = 2'd2;

// Durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] counter;
reg ped_shortened;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        counter <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        case (state)
            RED: begin
                if (counter == 0) begin
                    state <= GREEN;
                    counter <= GREEN_TIME;
                    ped_shortened <= 1'b0;
                end else begin
                    counter <= counter - 1;
                end
            end
            GREEN: begin
                // Shorten green on pass_request if not already shortened and time > 10
                if (pass_request && !ped_shortened && (counter > SHORT_GREEN)) begin
                    counter <= SHORT_GREEN;
                    ped_shortened <= 1'b1;
                end else if (counter == 0) begin
                    state <= YELLOW;
                    counter <= YELLOW_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            YELLOW: begin
                if (counter == 0) begin
                    state <= RED;
                    counter <= RED_TIME;
                end else begin
                    counter <= counter - 1;
                end
            end
            default: begin
                state <= RED;
                counter <= RED_TIME;
                ped_shortened <= 1'b0;
            end
        endcase
    end
end

// Outputs driven by current state
always @(*) begin
    red = (state == RED);
    yellow = (state == YELLOW);
    green = (state == GREEN);
    clock = counter;
end

endmodule