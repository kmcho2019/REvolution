module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Binary state encoding
localparam [1:0] 
    ST_RED    = 2'b00,
    ST_YELLOW = 2'b01,
    ST_GREEN  = 2'b10;

reg [1:0] state;
reg [7:0] counter;

assign clock = counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_RED;
        counter <= 10;
        {red, yellow, green} <= 3'b100;
    end else begin
        case (state)
            ST_RED: begin
                if (counter == 0) begin
                    state <= ST_GREEN;
                    counter <= 60;
                    {red, yellow, green} <= 3'b001;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_YELLOW: begin
                if (counter == 0) begin
                    state <= ST_RED;
                    counter <= 10;
                    {red, yellow, green} <= 3'b100;
                end else begin
                    counter <= counter - 1;
                end
            end
            
            ST_GREEN: begin
                // Handle pedestrian request
                if (pass_request && (counter > 10)) begin
                    counter <= 10;
                end else if (counter == 0) begin
                    state <= ST_YELLOW;
                    counter <= 5;
                    {red, yellow, green} <= 3'b010;
                end else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

endmodule