module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding using localparam
localparam [1:0] IDLE      = 2'b00;
localparam [1:0] S1_RED    = 2'b01;
localparam [1:0] S2_YELLOW = 2'b10;
localparam [1:0] S3_GREEN  = 2'b11;

// Timing parameters
localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] REQ_TIME    = 6'd10;

reg [1:0] current_state, next_state;
reg [5:0] cnt;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:      next_state = S1_RED;
        S1_RED:    next_state = (cnt == 6'd1) ? S3_GREEN : S1_RED;
        S2_YELLOW: next_state = (cnt == 6'd1) ? S1_RED : S2_YELLOW;
        S3_GREEN:  next_state = (cnt == 6'd1) ? S2_YELLOW : S3_GREEN;
        default:   next_state = IDLE;
    endcase
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        case (current_state)
            IDLE:      cnt <= RED_TIME;
            S1_RED:    cnt <= (cnt == 6'd1) ? GREEN_TIME : cnt - 1'b1;
            S2_YELLOW: cnt <= (cnt == 6'd1) ? RED_TIME : cnt - 1'b1;
            S3_GREEN: begin
                if (pass_request && (cnt > REQ_TIME))
                    cnt <= REQ_TIME;
                else
                    cnt <= (cnt == 6'd1) ? YELLOW_TIME : cnt - 1'b1;
            end
            default: cnt <= RED_TIME;
        endcase
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {red, yellow, green} <= 3'b000;
    end else begin
        case (current_state)
            IDLE:      {red, yellow, green} <= 3'b000;
            S1_RED:    {red, yellow, green} <= 3'b100;
            S2_YELLOW: {red, yellow, green} <= 3'b010;
            S3_GREEN:  {red, yellow, green} <= 3'b001;
            default:   {red, yellow, green} <= 3'b000;
        endcase
    end
end

assign clock = cnt;

endmodule