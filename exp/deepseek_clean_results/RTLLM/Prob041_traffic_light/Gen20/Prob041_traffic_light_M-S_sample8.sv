module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg red,
    output reg yellow,
    output reg green
);

reg [7:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
        counter <= 10; // Red time
    end else begin
        counter <= counter - 1;
        
        if (green && pass_request && (counter > 10))
            counter <= 10;
            
        if (counter == 0) begin
            if (red) begin
                red <= 0;
                green <= 1;
                counter <= 60; // Green time
            end else if (yellow) begin
                yellow <= 0;
                red <= 1;
                counter <= 10; // Red time
            end else if (green) begin
                green <= 0;
                yellow <= 1;
                counter <= 5; // Yellow time
            end
        end
    end
end

endmodule