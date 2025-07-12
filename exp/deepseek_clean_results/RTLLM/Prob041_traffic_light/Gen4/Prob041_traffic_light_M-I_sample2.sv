module traffic_light #(
    parameter RED_TIME    = 8'd10,
    parameter YELLOW_TIME = 8'd5,
    parameter GREEN_TIME  = 8'd60,
    parameter REQ_TIME    = 8'd10
)(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// One-hot state encoding
localparam [3:0] 
    ST_IDLE   = 4'b0001,
    ST_RED    = 4'b0010,
    ST_YELLOW = 4'b0100,
    ST_GREEN  = 4'b1000;

reg [3:0] state;
reg [7:0] counter;

assign clock = counter;

// State machine and timing control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_IDLE;
        counter <= RED_TIME;
        {red, yellow, green} <= 3'b000;
    end else begin
        casez (state)
            ST_IDLE: begin
                state <= ST_RED;
                counter <= RED_TIME;
                {red, yellow, green} <= 3'b100;
            end
            
            ST_RED: begin
                if (counter == 0) begin
                    state <= ST_GREEN;
                    counter <= GREEN_TIME;
                    {red, yellow, green} <= 3'b001;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_YELLOW: begin
                if (counter == 0) begin
                    state <= ST_RED;
                    counter <= RED_TIME;
                    {red, yellow, green} <= 3'b100;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_GREEN: begin
                // Handle pedestrian request
                if (pass_request && (counter > REQ_TIME)) begin
                    counter <= REQ_TIME;
                end else if (counter == 0) begin
                    state <= ST_YELLOW;
                    counter <= YELLOW_TIME;
                    {red, yellow, green} <= 3'b010;
                end else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

endmodule