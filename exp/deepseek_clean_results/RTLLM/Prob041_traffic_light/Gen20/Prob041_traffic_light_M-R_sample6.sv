module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

localparam [1:0] S_RED    = 2'b00;
localparam [1:0] S_YELLOW = 2'b01;
localparam [1:0] S_GREEN  = 2'b10;

localparam GREEN_TIME = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME = 10;
localparam MIN_GREEN = 10;

reg [1:0] state, next_state;
reg [5:0] counter;
wire counter_expired = (counter == 1);
wire pedestrian_shorten = pass_request && (state == S_GREEN) && (counter > MIN_GREEN);

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_RED:    next_state = counter_expired ? S_GREEN  : S_RED;
        S_YELLOW: next_state = counter_expired ? S_RED    : S_YELLOW;
        S_GREEN:  next_state = counter_expired ? S_YELLOW : S_GREEN;
        default:  next_state = S_RED;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= RED_TIME;
    end else begin
        if (pedestrian_shorten) begin
            counter <= MIN_GREEN;
        end else if (counter_expired) begin
            case (state)
                S_RED:    counter <= GREEN_TIME;
                S_YELLOW: counter <= RED_TIME;
                S_GREEN:  counter <= YELLOW_TIME;
                default:  counter <= RED_TIME;
            endcase
        end else begin
            counter <= counter - 1;
        end
    end
end

// Output logic
assign red    = (state == S_RED);
assign yellow = (state == S_YELLOW);
assign green  = (state == S_GREEN);
assign clock  = counter;

endmodule