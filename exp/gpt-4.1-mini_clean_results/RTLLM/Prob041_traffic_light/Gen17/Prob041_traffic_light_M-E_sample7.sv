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
    typedef enum reg [1:0] {
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10
    } state_t;

    // Duration parameters
    localparam integer RED_TIME    = 8'd10;
    localparam integer YELLOW_TIME = 8'd5;
    localparam integer GREEN_TIME  = 8'd60;
    localparam integer SHORT_GREEN = 8'd10;

    reg [7:0] timer;
    reg       green_shortened; // flag to avoid multiple shortenings of green phase
    reg       pass_request_sync; // synchronize pass_request

    state_t   state, next_state;

    // Synchronize pass_request to clk domain to avoid metastability
    reg pass_request_d1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pass_request_d1 <= 1'b0;
        else
            pass_request_d1 <= pass_request;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pass_request_sync <= 1'b0;
        else
            pass_request_sync <= pass_request_d1;
    end

    // State and timer sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= RED;
            timer           <= RED_TIME;
            green_shortened <= 1'b0;
        end else begin
            // Timer countdown
            if (timer != 0)
                timer <= timer - 1;

            // State transitions
            case (state)
                RED: begin
                    if (timer == 0) begin
                        state           <= GREEN;
                        timer           <= GREEN_TIME;
                        green_shortened <= 1'b0;
                    end
                end
                GREEN: begin
                    // Pedestrian button shortens green timer if conditions met and not shortened yet
                    if ((pass_request_sync == 1'b1) && (timer > SHORT_GREEN) && (green_shortened == 1'b0)) begin
                        timer           <= SHORT_GREEN;
                        green_shortened <= 1'b1;
                    end else if (timer == 0) begin
                        state <= YELLOW;
                        timer <= YELLOW_TIME;
                    end
                end
                YELLOW: begin
                    if (timer == 0) begin
                        state <= RED;
                        timer <= RED_TIME;
                    end
                end
                default: begin
                    state           <= RED;
                    timer           <= RED_TIME;
                    green_shortened <= 1'b0;
                end
            endcase
        end
    end

    // Output logic: registered outputs driven by current state
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
            clock  <= timer;
        end
    end

endmodule