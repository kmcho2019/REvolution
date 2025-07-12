module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

localparam IDLE   = 2'd0;
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;
reg ped_shortened;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        ped_shortened <= 1'b0;
    end else begin
        if (timer > 0)
            timer <= timer - 1;

        case (state)
            RED: if (timer == 0) begin
                state <= GREEN;
                timer <= GREEN_TIME;
                ped_shortened <= 1'b0;
            end

            GREEN: begin
                if (pass_request && !ped_shortened && (timer > SHORT_GREEN)) begin
                    timer <= SHORT_GREEN;
                    ped_shortened <= 1'b1;
                end else if (timer == 0) begin
                    state <= YELLOW;
                    timer <= YELLOW_TIME;
                    ped_shortened <= 1'b0;
                end
            end

            YELLOW: if (timer == 0) begin
                state <= RED;
                timer <= RED_TIME;
                ped_shortened <= 1'b0;
            end

            default: begin
                state <= RED;
                timer <= RED_TIME;
                ped_shortened <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    red = (state == RED);
    yellow = (state == YELLOW);
    green = (state == GREEN);
    clock = timer;
end

endmodule