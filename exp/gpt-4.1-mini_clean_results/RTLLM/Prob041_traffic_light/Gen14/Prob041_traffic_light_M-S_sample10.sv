module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RED     = 2'd1;
    localparam YELLOW  = 2'd2;
    localparam GREEN   = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state;
    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= RED;
            counter <= RED_TIME;
        end else begin
            if (counter == 0) begin
                case(state)
                    RED:    begin state <= GREEN;  counter <= GREEN_TIME;  end
                    GREEN:  begin state <= YELLOW; counter <= YELLOW_TIME; end
                    YELLOW: begin state <= RED;    counter <= RED_TIME;    end
                    default: begin state <= RED; counter <= RED_TIME; end
                endcase
            end else begin
                // Pedestrian button pressed and green light with more than 10 clocks left
                if ((state == GREEN) && pass_request && (counter > SHORT_GREEN)) begin
                    counter <= SHORT_GREEN;
                end else begin
                    counter <= counter - 1;
                end
            end
        end
    end

    // Outputs directly from state
    always @(*) begin
        red    = (state == RED);
        yellow = (state == YELLOW);
        green  = (state == GREEN);
        clock  = counter;
    end

endmodule