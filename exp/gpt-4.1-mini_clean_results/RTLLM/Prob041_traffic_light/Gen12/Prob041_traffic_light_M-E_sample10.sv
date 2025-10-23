module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding using 2 bits as parameter enumeration
    localparam [1:0]
        IDLE    = 2'd0,
        RED     = 2'd1,
        YELLOW  = 2'd2,
        GREEN   = 2'd3;

    // Timing parameters (in clock cycles)
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;

    // State register and timer register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 8'd0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Next state and timer logic combinational block
    always @(*) begin
        // Default assignments to hold state and timer
        next_state = state;
        next_timer = timer;

        case (state)
            IDLE: begin
                // Immediately go to RED with RED_TIME timer
                next_state = RED;
                next_timer = RED_TIME;
            end
            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            GREEN: begin
                // Shorten green on pass_request if timer > SHORT_GREEN
                if (pass_request && (timer > SHORT_GREEN)) begin
                    next_timer = SHORT_GREEN;
                end else if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            default: begin
                next_state = IDLE;
                next_timer = 8'd0;
            end
        endcase
    end

    // Output logic based on state, registered for glitch-free output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            clock <= timer;
            case (state)
                RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

endmodule