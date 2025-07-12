module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter G_TIME = 60;
parameter Y_TIME = 5;
parameter R_TIME = 10;
parameter MIN_G = 10;

// State encoding
reg [1:0] state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= R_TIME;
    end else begin
        cnt <= cnt - 1;
        case (state)
            RED:    if (cnt == 1) begin state <= GREEN;  cnt <= G_TIME; end
            YELLOW: if (cnt == 1) begin state <= RED;    cnt <= R_TIME; end
            GREEN:  begin
                if (pass_request && cnt > MIN_G) cnt <= MIN_G;
                if (cnt == 1) begin state <= YELLOW; cnt <= Y_TIME; end
            end
        endcase
    end
end

// Output assignments
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule