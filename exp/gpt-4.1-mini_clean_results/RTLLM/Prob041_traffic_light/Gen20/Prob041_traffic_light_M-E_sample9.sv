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
localparam [1:0]
    IDLE   = 2'd0,
    RED    = 2'd1,
    GREEN  = 2'd2,
    YELLOW = 2'd3;

// Timing constants
localparam [7:0]
    RED_TIME    = 8'd10,
    GREEN_TIME  = 8'd60,
    YELLOW_TIME = 8'd5,
    SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] counter, next_counter;

wire ped_req_shorten = (pass_request && (state == GREEN) && (counter > SHORT_GREEN));

// Sequential state and counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= IDLE;
        counter <= 8'd0;
    end else begin
        state   <= next_state;
        counter <= next_counter;
    end
end

// Next-state and counter logic combinational
always @(*) begin
    next_state   = state;
    next_counter = counter;

    case (state)
        IDLE: begin
            // On reset, initialize to RED state with red timer
            next_state   = RED;
            next_counter = RED_TIME;
        end
        RED: begin
            if (counter == 8'd0) begin
                next_state   = GREEN;
                next_counter = GREEN_TIME;
            end else begin
                next_counter = counter - 8'd1;
            end
        end
        GREEN: begin
            if (ped_req_shorten) begin
                // Shorten green to 10 if remaining > 10 and pass_request asserted
                next_counter = SHORT_GREEN;
            end else if (counter == 8'd0) begin
                next_state   = YELLOW;
                next_counter = YELLOW_TIME;
            end else begin
                next_counter = counter - 8'd1;
            end
        end
        YELLOW: begin
            if (counter == 8'd0) begin
                next_state   = RED;
                next_counter = RED_TIME;
            end else begin
                next_counter = counter - 8'd1;
            end
        end
        default: begin
            next_state   = IDLE;
            next_counter = 8'd0;
        end
    endcase
end

// Output logic synchronous
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red    <= 1'b0;
        yellow <= 1'b0;
        green  <= 1'b0;
        clock  <= 8'd0;
    end else begin
        clock <= counter;
        case (state)
            RED: begin
                red    <= 1'b1;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
            GREEN: begin
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b1;
            end
            YELLOW: begin
                red    <= 1'b0;
                yellow <= 1'b1;
                green  <= 1'b0;
            end
            default: begin // IDLE and any unexpected state
                red    <= 1'b0;
                yellow <= 1'b0;
                green  <= 1'b0;
            end
        endcase
    end
end

endmodule