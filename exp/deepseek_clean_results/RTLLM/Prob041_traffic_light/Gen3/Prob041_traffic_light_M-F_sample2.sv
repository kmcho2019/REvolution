module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,  // Restored to 8 bits
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

reg [1:0] state;
reg [7:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 8'd10;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        // Handle pedestrian request during green
        if (pass_request && (state == GREEN)) begin
            if (cnt > 8'd10) begin
                cnt <= 8'd10;
            end
        end
        
        // Countdown and state transitions
        if (cnt > 8'd1) begin
            cnt <= cnt - 8'd1;
        end else begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= 8'd60;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= 8'd10;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= 8'd5;
                end
            endcase
        end
        
        // Output assignments
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
        clock <= cnt;
    end
end

endmodule