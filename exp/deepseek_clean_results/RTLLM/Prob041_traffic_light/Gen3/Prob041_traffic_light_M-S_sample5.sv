module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Binary state encoding
parameter IDLE     = 2'b00;
parameter S1_RED   = 2'b01;
parameter S2_YELLOW = 2'b10;
parameter S3_GREEN = 2'b11;

// Timing parameters
parameter RED_TIME    = 6'd10;
parameter YELLOW_TIME = 6'd5;
parameter GREEN_TIME  = 6'd60;
parameter REQ_TIME    = 6'd10;

reg [1:0] state;  // 2-bit state
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b000;
    end else begin
        case (state)
            IDLE: begin
                state <= S1_RED;
                cnt <= RED_TIME;
                {red, yellow, green} <= 3'b100;
            end
            
            S1_RED: begin
                if (cnt == 6'd1) begin
                    state <= S3_GREEN;
                    cnt <= GREEN_TIME;
                    {red, yellow, green} <= 3'b001;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            S2_YELLOW: begin
                if (cnt == 6'd1) begin
                    state <= S1_RED;
                    cnt <= RED_TIME;
                    {red, yellow, green} <= 3'b100;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            S3_GREEN: begin
                if (pass_request && (cnt > REQ_TIME)) begin
                    cnt <= REQ_TIME;
                end else if (cnt == 6'd1) begin
                    state <= S2_YELLOW;
                    cnt <= YELLOW_TIME;
                    {red, yellow, green} <= 3'b010;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
        endcase
    end
end

assign clock = cnt;

endmodule