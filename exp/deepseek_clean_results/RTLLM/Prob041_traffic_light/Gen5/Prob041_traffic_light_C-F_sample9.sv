module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Gray-coded state encoding for power efficiency
parameter [1:0] IDLE      = 2'b00;
parameter [1:0] RED_ST    = 2'b01;
parameter [1:0] GREEN_ST  = 2'b11;
parameter [1:0] YELLOW_ST = 2'b10;

// Timing parameters
parameter GREEN_TIME  = 6'd60;
parameter YELLOW_TIME = 6'd5;
parameter RED_TIME    = 6'd10;
parameter REQ_TIME    = 6'd10;

reg [1:0] state;
reg [5:0] cnt;

assign clock = cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        {red, yellow, green} <= 3'b100;
    end else begin
        case (state)
            IDLE: begin
                state <= RED_ST;
                cnt <= RED_TIME;
                {red, yellow, green} <= 3'b100;
            end
            
            RED_ST: begin
                if (cnt == 6'd1) begin
                    state <= GREEN_ST;
                    cnt <= GREEN_TIME;
                    {red, yellow, green} <= 3'b001;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            GREEN_ST: begin
                // Handle pedestrian request
                if (pass_request && (cnt > REQ_TIME)) begin
                    cnt <= REQ_TIME;
                end
                
                if (cnt == 6'd1) begin
                    state <= YELLOW_ST;
                    cnt <= YELLOW_TIME;
                    {red, yellow, green} <= 3'b010;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            YELLOW_ST: begin
                if (cnt == 6'd1) begin
                    state <= RED_ST;
                    cnt <= RED_TIME;
                    {red, yellow, green} <= 3'b100;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
        endcase
    end
end

endmodule