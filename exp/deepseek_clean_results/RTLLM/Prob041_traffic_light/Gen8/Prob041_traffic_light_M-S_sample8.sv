module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
localparam RED = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN = 2'b10;

reg [1:0] state;
reg [7:0] cnt;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= 10; // Initial red time
    end else begin
        // Handle counter
        if (pass_request && (state == GREEN) && (cnt > 10))
            cnt <= 10;
        else if (cnt == 1) begin
            case (state)
                RED: begin
                    state <= GREEN;
                    cnt <= 60;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= 10;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= 5;
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments (combinational)
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule